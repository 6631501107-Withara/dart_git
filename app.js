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
   const { username, password } = req.body;
  if (!username || !password) return res.status(400).send('Missing username or password');

  const sql = 'SELECT * FROM users WHERE username = ?';
  con.query(sql, [username], (err, results) => {
    if (err) return res.status(500).send('Database error');
    if (results.length === 0) return res.status(401).send('Wrong username');

    const user = results[0];
    bcrypt.compare(password, user.password, (err, same) => {
      if (err) return res.status(500).send('Password compare error');
      if (!same) return res.status(401).send('Wrong password');
      return res.json({ message: 'Login success', userId: user.id });
    });
  });

});

// (3) Search expenses by keyword  <-- วางก่อน
app.get('/expenses/search', (req, res) => {
  





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
