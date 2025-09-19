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

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

//GET attendance by employee ID
app.get("/api/attendance/:employeeId/:attendanceId", async (req, res) => {
  try {
    const { employeeId, attendanceId } = req.params;
    const result = await pool.query(
      "SELECT * FROM attendances WHERE employee_id = $1 AND attendance_id = $2",
      [employeeId, attendanceId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Attendances not found" });
    }
    console.log(result.rows[0]);
    res.json(result.rows[0]);
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
      clock_in_photo_url,
      clock_in_latitude,
      clock_in_longitude,
    } = req.body;
    const result = await pool.query(
      `INSERT INTO attendances 
      (attendance_date, day_name, check_in, check_out, status, employee_id, 
      clock_in_photo_url, clock_in_latitude, clock_in_longitude) 
   VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
   RETURNING *`,
      [
        attendance_date,
        day_name,
        check_in,
        check_out,
        status,
        employee_id || null,
        clock_in_photo_url,
        clock_in_latitude,
        clock_in_longitude,
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
    const {
      employee_id,
      check_out,
      clock_out_photo_url,
      clock_out_latitude,
      clock_out_longitude,
    } = req.body;

    const today = new Date().toLocaleDateString("en-US", {
      month: "short", // "Aug"
      day: "numeric", // "1"
      year: "numeric", // "2025"
    });

    const result = await pool.query(
      `UPDATE attendances
       SET check_out=$1,
       clock_out_photo_url = $2,
       clock_out_latitude = $3,
       clock_out_longitude = $4
       WHERE employee_id=$5 AND attendance_date=$6
       RETURNING *`,
      [
        check_out || null,
        clock_out_photo_url || null,
        clock_out_latitude || null,
        clock_out_longitude || null,
        employee_id,
        today,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Attendance not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.log(err);
    res.status(500).json({ error: err.message });
  }
});

// Start server
app.listen(PORT, () =>
  console.log(`Portfolio API running at http://localhost:${PORT}`)
);
