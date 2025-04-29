const fs = require("fs");

const content = fs.readFileSync("./line-to-convert.sql", "utf8");

// mssql date format
const regex =
  /'([A-Za-z]{3}\s+\d{1,2}\s+\d{4}\s+\d{2}:\d{2}:\d{2}:\d{3}(?:AM|PM))'/g;

function toMysqlDate(mssqlDateStr) {
  // e.g. "Jan 13 2014 12:00:00:000AM"
  // 1) Insert a space before AM/PM
  // 2) Split out the millisecond section
  const normalized = mssqlDateStr
    .replace(/(AM|PM)$/, " $1") // "…000AM" → "…000 AM"
    .replace(/:(\d{3}) (AM|PM)/, ".$1 $2"); // ":000 AM" → ".000 AM"

  // Use Date.parse (which accepts "MMM DD YYYY hh:mm:ss.SSS A")
  const dt = new Date(normalized);
  if (isNaN(dt)) throw new Error("Invalid date: " + mssqlDateStr);

  // Build YYYY-MM-DD HH:MM:SS
  const pad = (n) => String(n).padStart(2, "0");
  const YYYY = dt.getFullYear();
  const MM = pad(dt.getMonth() + 1);
  const DD = pad(dt.getDate());
  const hh = pad(dt.getHours());
  const mm = pad(dt.getMinutes());
  const ss = pad(dt.getSeconds());

  return `${YYYY}-${MM}-${DD} ${hh}:${mm}:${ss}`;
}

const convertedContent = content.replace(regex, (match, mssqlDate) => {
  const convertedDate = toMysqlDate(mssqlDate.trim());

  return `'${convertedDate}'`;
});

fs.writeFileSync("./result.sql", convertedContent);
