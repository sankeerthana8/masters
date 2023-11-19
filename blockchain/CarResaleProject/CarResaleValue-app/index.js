var express = require("express");
const path = require("path");

var app = express();
app.use(express.static(path.join(__dirname, "src")));
//app.use(express.static('C:\Users\DELL\OneDrive\Desktop\blockchain\CarResaleProject\CarReSaleValue-contract\build\contracts'));

app.get("/", function (req, res) {
  res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/buy", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "buy.html"));
});

app.get("/sell", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "sell.html"));
});

app.get("/edit", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "edit.html"));
});

app.get("/isSold", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "isSold.html"));
});

app.get("/viewCars", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "viewCars.html"));
});

app.get("/searchCars", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "search.html"));
});

app.get("/expiration", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "expiration.html"));
});

app.get("/deleteCar", function (req, res) {
  res.sendFile(path.join(__dirname, "/src", "deleteCar.html"));
});

app.listen(process.env.PORT || 3000, function () {
  console.log("CarResale Dapp listening on port 3000!");
});
