import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { Chatroom, Message, User } from "./interface";

const app = admin.initializeApp();
const db = app.firestore();

export const onMessageCreated = functions
    .region("asia-east2")
    .firestore.document("/chatrooms/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context ) => {
      const chatroomId = context.params["chatroomId"] as string;

      const message = snapshot.data() as Message;

      const chatroomSnapshot = await db
          .collection("chatrooms")
          .doc(chatroomId)
          .get();

      const chatroom = chatroomSnapshot.data() as Chatroom;

      const authorSnapshot = await db.collection("users").doc(message.authorId).get();
      const author = authorSnapshot.data() as User;

      const unreadUpdate = chatroom.participants
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
        // "unread.luke": increment(1),
        ...unreadUpdate,
        latestMessageAt: message.createdAt,
      });
      // 1. Get the target chatroom
      // 2. Get all participants
      // 3. Update chatroom.latestMessage, chatroom.lastestMessageAt, chatroom.unread
      // 4. Optional: Send notification to all participants except the sender
    });
