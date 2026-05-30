const express = require("express");
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const storage = [];
const old_storage = [];

let server = {
    id: null,
    last_handout: Date.now() - 10000,
}

app.get("/get", (req, res) => {
    if (Date.now() - server.last_handout >= 10000) {
        if (storage.length === 0) {
            return res.status(404).json({ error: "No data available" });
        }

        server.id = storage[Math.floor(Math.random() * storage.length)].server_id;
        server.last_handout = Date.now();
    }
        
    res.json({ server_id: server.id });
});

app.get("/add", (req, res) => {
    let { server_id, time_remaining } = req.query || {};

    if (!server_id) {
        console.log("Missing server_id in request");
        return res.status(400).json({ error: "Missing server_id" });
    }

    if (old_storage.some(entry => entry.server_id === server_id)) {
        return res.status(409).json({ error: "Server ID already exists in old storage" });
    }

    if (!time_remaining) { time_remaining = 60; }
    storage.push({ server_id, time_remaining });
    old_storage.push({ server_id, time_remaining });

    setTimeout(() => {
        const oldIndex = old_storage.findIndex(entry => entry.server_id === server_id);
        if (oldIndex !== -1) { old_storage.splice(oldIndex, 1); }
    }, 4 * 60 * 1000);

    setTimeout(() => {
        const index = storage.findIndex(entry => entry.server_id === server_id);
        if (index !== -1) { storage.splice(index, 1); }
    }, time_remaining * 1000);

    console.log(`Added server_id: ${server_id} with time_remaining: ${time_remaining} seconds`);
    res.json({ success: true, message: "Data added successfully" });
});

app.listen(2231, () => {
    console.log("Server started on port 2231");
});
