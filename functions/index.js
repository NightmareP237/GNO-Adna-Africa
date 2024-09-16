/* eslint-disable max-len */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest, HttpsError} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
// const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const functions = require("firebase-functions");
// functions.region("asia-northeast3")
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started
admin.initializeApp();
const fcm = admin.messaging();
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.checkHeath =functions.region("us-central1").https.onCall(async (data, context)=>{
  return "the function is offiline";
});
exports.sendNotification = functions.region("us-central1").https.onCall(async (data, context)=>{
  const title= data.title;
  const body =data.body;
  const image =data.image;
  const token = data.token;
  try {
    const playload = {
      token: token,
      notification: {
        title: title,
        body: body,
        image: image,
      },
      data: {
        body: body,
      },
    };
    return fcm.send(playload).then((reponse)=>{
      return {success: true, response: "successfully sent message " +reponse};
    }).catch((error) => {
      return {error: error};
    });
  } catch (error) {
    throw HttpsError.call("invalid-argument "+ error);
  }
});
