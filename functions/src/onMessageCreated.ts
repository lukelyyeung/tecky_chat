import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { Chatroom, Message, NotificationSetting, User } from "./interface";

const app = admin.initializeApp();
const db = app.firestore();
const messaging = app.messaging();

export const onMessageCreated = functions
    .region("asia-east2")
    .firestore.document("/chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context ) => {
      const chatroomId = context.params["chatroomId"] as string;
      const messageId = context.params["messageId"] as string;

      const message = snapshot.data() as Message;

      const chatroomSnapshot = await db
          .collection("chatrooms")
          .doc(chatroomId)
          .get();

      const chatroom = chatroomSnapshot.data() as Chatroom;

      const authorSnapshot = await db.collection("users").doc(message.authorId).get();
      const author = authorSnapshot.data() as User;

      const recipients = chatroom.participants
          .filter((participantId) => participantId !== author.id);

      const unreadUpdate = recipients
          .reduce<Record<string, admin.firestore.FieldValue>>((acc, cur) => {
            if (cur !== message.authorId) {
              acc[`unread.${cur}`] = admin.firestore.FieldValue.increment(1);
            }
            return acc;
          }, {});

      await db.collection("chatrooms").doc(chatroomId).update({
        latestMessage: {
          ...message,
          displayName: author.displayName,
        },
        ...unreadUpdate,
        latestMessageAt: message.createdAt,
      });

      const notificationSettingSnapshot = await db.collection("notificationSettings")
          .where("userId", "in", recipients).get();

      const notificationSettings = notificationSettingSnapshot
          .docs
          .map((doc) => doc.data()) as NotificationSetting[];

      await messaging.sendAll(notificationSettings.map((setting) => {
        return {
          token: setting.token,
          notification: {
            title: "You have a new message!",
            body: `${author.displayName}: ${message.textContent}`,
          },
          data: {
            authorId: author.id,
            messageId,
            chatroomId,
          },
        };
      }));

      // 1. Get the target chatroom
      // 2. Get all participants
      // 3. Update chatroom.latestMessage, chatroom.lastestMessageAt, chatroom.unread
      // 4. Optional: Send notification to all participants except the sender
    });
