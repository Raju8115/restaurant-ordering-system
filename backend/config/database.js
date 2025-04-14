import mysql from "mysql2";

// create the connection to database

const db = mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASS || "",
    database: process.env.DB_NAME || "db_restaurant"
});


db.connect((err) => {
  if (err) {
    console.error("MySQL connection error: ", err);
    return;
  }
  console.log("Connected to MySQL!");
});

export default db;
