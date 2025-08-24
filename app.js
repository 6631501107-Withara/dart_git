const express = require('express');
const bcrypt = require('bcrypt');
const app = express();
const con = require('./db');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.urlencoded({ extended: true }));

//--------------- register ----------------
app.post('/register', (req, res) => {
  



});

//--------------- login ----------------
app.post('/login', (req, res) => {
  




});

// (3) Search expenses by keyword  <-- วางก่อน
app.get('/expenses/search', (req, res) => {
  const { userId, q } = req.query;
    if (!userId) return res.status(400).send('Missing userId');
    if (!q || q.trim() === '') return res.json([]);

  const keyword = `%${q}%`;
  const sql = `
    SELECT id, item, paid, \`date\`
    FROM expense
    WHERE user_id = ? AND LOWER(item) LIKE LOWER(?)
    ORDER BY \`date\` ASC, id ASC
  `;
  con.query(sql, [userId, keyword], (err, results) => {
    if (err) return res.status(500).send('Database error!');
    res.json(results);
  });
});

// (2) Today's expenses              <-- วางก่อน
app.get('/expenses/today/:userId', (req, res) => {
  





});

// (1) All expenses (generic)        <-- วางท้ายสุด
app.get('/expenses/:userId', (req, res) => {
  






});


// (4) Add a new expense
app.post('/expenses', (req, res) => {
  






});


// (5) Delete an expense by id
app.delete('/expenses/:id', (req, res) => {
  





});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
