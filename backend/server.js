import express from "express";
import { randomUUID } from "crypto";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  PutCommand,
  ScanCommand
} from "@aws-sdk/lib-dynamodb";

const app = express();

const port = process.env.PORT || 8080;
const tableName = process.env.WAITLIST_TABLE || "andrews-waitlist";

const client = DynamoDBDocumentClient.from(
  new DynamoDBClient({})
);

app.use(express.json());

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

app.get("/api/waitlist", async (req, res) => {
  try {
    const result = await client.send(
      new ScanCommand({
        TableName: tableName
      })
    );

    res.json(result.Items || []);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Unable to load waitlist"
    });
  }
});

app.post("/api/waitlist", async (req, res) => {
  const guestName = String(req.body.guestName || "").trim();
  const partySize = Number(req.body.partySize);

  if (!guestName || partySize < 1) {
    return res.status(400).json({
      message: "Guest name and party size are required"
    });
  }

  const guest = {
    id: randomUUID(),
    guestName,
    partySize,
    status: "waiting",
    createdAt: Date.now()
  };

  try {
    await client.send(
      new PutCommand({
        TableName: tableName,
        Item: guest
      })
    );

    res.status(201).json(guest);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Unable to add guest"
    });
  }
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Andrews backend running on port ${port}`);
});
