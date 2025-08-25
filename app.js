const express = require('express');
const bcrypt = require('bcrypt');
const app = express();
const con = require('./db');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.urlencoded({ extended: true }));



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

   const userId = req.params.userId;
  const sql = `
    SELECT id, item, paid, \`date\`
    FROM expense
    WHERE user_id = ? AND DATE(\`date\`) = CURDATE()
    ORDER BY \`date\` ASC, id ASC
  `;
  con.query(sql, [userId], (err, results) => {
    if (err) return res.status(500).send('Database error!');
    res.json(results);
  });
});

// (1) All expenses (generic)        <-- วางท้ายสุด
app.get('/expenses/:userId', (req, res) => {

   const userId = req.params.userId;
  const sql = `
    SELECT id, item, paid, \`date\`
    FROM expense
    WHERE user_id = ?
    ORDER BY \`date\` ASC, id ASC
  `;
  con.query(sql, [userId], (err, results) => {
    if (err) return res.status(500).send('Database error!');
    res.json(results);
  });
});


// (4) Add a new expense
app.post('/expenses', (req, res) => {
  let { userId, item, paid } = req.body;
  console.log('POST /expenses ->', req.body);   // <--- ดูว่า userId ที่ client ส่งมาเป็นอะไร
  userId = Number(userId);
  paid = Number(paid);

  if (!Number.isInteger(userId) || !item || !Number.isFinite(paid)) {
    return res.status(400).send('Missing/invalid userId, item or paid');
  }

  const sql = `
    INSERT INTO expense (user_id, item, paid, date)
    VALUES (?, ?, ?, NOW())
  `;
  con.query(sql, [userId, item, paid], (err, result) => {
    if (err) return res.status(500).send('Database insert error');
    res.status(201).json({ message: 'Inserted', id: result.insertId });
  });
});


// (5) Delete an expense by id
app.delete('/expenses/:id', (req, res) => {
   const id = req.params.id;
  const sql = 'DELETE FROM expense WHERE id = ?';
  con.query(sql, [id], (err, result) => {
    if (err) return res.status(500).send('Database delete error');
    if (result.affectedRows === 0) return res.status(404).send('Expense not found');
    res.json({ message: 'Deleted' });
  });
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
