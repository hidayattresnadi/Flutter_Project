const { Pool } = require("pg");

const pool = new Pool({
  user: "postgres", // username PostgreSQL
  host: "localhost",
  database: "hr_attendance_app", // nama database
  password: "postgres", // password PostgreSQL
  port: 5432,
});

module.exports = pool;
