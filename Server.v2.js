const express = require("express");
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const storage = [];

app.get("/report", (req, res) => {
    console.log("Created")
    const { id, airdrop, mansion, jewelry } = req.query || {};

    if (!id) {
        console.log("Missing id in request");
        return res.status(400).json({ error: "Missing id" });
    }

    const existingEntryIndex = storage.findIndex(entry => entry.id === id);
    if (existingEntryIndex !== -1) {
        storage[existingEntryIndex] = { id, airdrop, mansion, jewelry, timestamp: Date.now() };
        console.log(`Updated report for id: ${id}`);
    } else {
        storage.push({ id, airdrop, mansion, jewelry, timestamp: Date.now() });
        console.log(`Added report for id: ${id}`);
        setTimeout(() => {
            const foundIndex = storage.findIndex(entry => entry.id === id);
            if (foundIndex !== -1) {
                storage.splice(foundIndex, 1);
                console.log(`Removed report for id: ${id}`);
            }
        }, 60000);
    }

    res.json({ success: true, message: "Report received" });
});

app.get("/get", (req, res) => {
    if (storage.length === 0) {
        return res.status(404).json({ error: "No data available" });
    }

    const { type } = req.query || {};

    if (type) {
        const filteredStorage = storage.filter(entry => entry[type] === "true");
        if (filteredStorage.length === 0) {
            return res.status(404).json({ error: `No data available for type: ${type}` });
        }

        const selected = filteredStorage[Math.floor(Math.random() * filteredStorage.length)];
        setTimeout(() => {
            const foundIndex = storage.findIndex(entry => entry.id === selected.id);
            if (foundIndex !== -1) {
                storage.splice(foundIndex, 1);
                console.log(`Removed report for id: ${selected.id}`);
            }
        }, 10000); 

        res.json({ success: true, data: selected });
    } else {
        res.json({ error: "Missing type parameter" });
    }
})

app.listen(1796, () => {
    console.log("Server started on port 1796");
});
