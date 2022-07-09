
export interface Chatroom {
  id: string;
  displayName?: string;
  iconUrl?: string;
  isGroup: boolean;
  participants: string[];
  participant: Record<string, boolean>;
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
  latestMessageAt: FirebaseFirestore.Timestamp;
  latestMessage?: LatestMessage;
}

export interface Message {
  id: string;
  textContent?: string;
  mediaFiles?: string[];
  authorId: string;
  type: "text" | "image" | "audio" | "video",
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}

export type LatestMessage = Message & { displayName: string };

export interface User {
  id: string;
  displayName: string;
  profileUrl?: string;
}
