const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const pool = require("./db");
const upload = require("./middleware/upload");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

// GET all portfolios, optional query: category=Mobile App
app.get("/api/portfolios", async (req, res) => {
  try {
    const { category } = req.query;
    let result;

    if (category) {
      result = await pool.query(
        "SELECT * FROM portfolios WHERE category = $1",
        [category]
      );
    } else {
      result = await pool.query("SELECT * FROM portfolios");
    }

    res.json(result.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: err.message });
  }
});

//GET portfolio by ID
app.get("/api/portfolios/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("SELECT * FROM portfolios WHERE id = $1", [
      id,
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Portfolio not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//DELETE portfolio
app.delete("/api/portfolios/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      "DELETE FROM portfolios WHERE id = $1 RETURNING *",
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Portfolio not found" });
    }
    res.json({ message: "Portfolio deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//POST create new portfolio
app.post("/api/portfolios", upload.single("file"), async (req, res) => {
  try {
    const {
      title,
      category,
      completion_date,
      description,
      project_link,
      technologies,
    } = req.body;

    if (!title || !category || !completion_date || !description) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    if (project_link && !/^https?:\/\/.+$/.test(project_link)) {
      return res.status(400).json({ error: "Invalid project_link format" });
    }

    const imagePath = req.file ? `/uploads/${req.file.filename}` : null;

    const result = await pool.query(
      `INSERT INTO portfolios 
       (title, category, completion_date, description, project_link, technologies, image_path) 
       VALUES ($1, $2, $3, $4, $5, $6, $7) 
       RETURNING *`,
      [
        title,
        category,
        completion_date,
        description,
        project_link,
        technologies,
        imagePath,
      ]
    );

    return res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//PUT update portfolio

app.put("/api/portfolios/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const {
      title,
      category,
      completion_date,
      description,
      project_link,
      technologies,
      image_path,
    } = req.body;

    const result = await pool.query(
      `UPDATE portfolios 
       SET title=$1, category=$2, completion_date=$3, description=$4, project_link=$5, technologies=$6, image_path=$7 
       WHERE id=$8 RETURNING *`,
      [
        title,
        category,
        completion_date,
        description,
        project_link,
        technologies,
        image_path || null,
        id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Portfolio not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.use("/uploads", express.static("uploads"));

// Start server
app.listen(PORT, () =>
  console.log(`Portfolio API running at http://localhost:${PORT}`)
);
