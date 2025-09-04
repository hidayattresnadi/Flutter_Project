const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const pool = require("./db");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

//GET attendances by employee ID
app.get("/api/attendance/:employeeId", async (req, res) => {
  try {
    const { employeeId } = req.params;
    const result = await pool.query(
      "SELECT * FROM attendances WHERE employee_id = $1 ORDER BY attendance_id ASC",
      [employeeId]
    );

    // if (result.rows.length === 0) {
    //   return res.status(404).json({ error: "Attendances not found" });
    // }

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//POST create new attendance (clock in)
app.post("/api/attendance/clockin", async (req, res) => {
  try {
    const {
      attendance_date,
      day_name,
      check_in,
      check_out,
      status,
      employee_id,
    } = req.body;
    const result = await pool.query(
      `INSERT INTO attendances (attendance_date, day_name, check_in, check_out, status, employee_id) 
   VALUES ($1, $2, $3, $4, $5, $6) 
   RETURNING *`,
      [
        attendance_date,
        day_name,
        check_in,
        check_out,
        status,
        employee_id || null,
      ]
    );

    return res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//PUT update attendance (clock out)

app.put("/api/attendance/clockout", async (req, res) => {
  try {
    const { employee_id, check_out } = req.body;

    const today = new Date().toLocaleDateString("en-US", {
      month: "short", // "Aug"
      day: "numeric", // "1"
      year: "numeric", // "2025"
    });

    const result = await pool.query(
      `UPDATE attendances
       SET check_out=$1
       WHERE employee_id=$2 AND attendance_date=$3
       RETURNING *`,
      [check_out || null, employee_id, today]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Attendance not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Start server
app.listen(PORT, () =>
  console.log(`Portfolio API running at http://localhost:${PORT}`)
);
