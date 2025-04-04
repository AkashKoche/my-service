const express = require('express');
const { Pool } = require('pg');
require('dotenv').config();

// Create a router instance
const router = express.Router();

// PostgreSQL connection pool
const pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

/**
 * GET /api/users
 * Retrieve all users from the database.
 */
router.get('/users', async (req, res) => {
    try {
        const { rows } = await pool.query('SELECT * FROM users');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

/**
 * POST /api/users
 * Add a new user to the database.
 */
router.post('/users', async (req, res) => {
    const { name, email } = req.body;

    // Validate input
    if (!name || !email) {
        return res.status(400).json({ error: 'Name and email are required' });
    }

    try {
        const { rows } = await pool.query(
            'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *',
            [name, email]
        );
        res.status(201).json(rows[0]);
    } catch (err) {
        console.error(err);

        // Handle duplicate email error
        if (err.code === '23505') {
            return res.status(409).json({ error: 'Email already exists' });
        }

        res.status(500).send('Server error');
    }
});

/**
 * GET /api/users/:id
 * Retrieve a specific user by ID.
 */
router.get('/users/:id', async (req, res) => {
    const { id } = req.params;

    try {
        const { rows } = await pool.query('SELECT * FROM users WHERE id = $1', [id]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'users not found' });
        }

        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

/**
 * PUT /api/users/:id
 * Update an existing user by ID.
 */
router.put('/users/:id', async (req, res) => {
    const { id } = req.params;
    const { name, email } = req.body;

    // Validate input
    if (!name && !email) {
        return res.status(400).json({ error: 'At least one field (name or email) is required' });
    }

    try {
        const { rows } = await pool.query(
            'UPDATE users SET name = COALESCE($1, name), email = COALESCE($2, email) WHERE id = $3 RETURNING *',
            [name, email, id]
        );

        if (rows.length === 0) {
            return res.status(404).json({ error: 'users not found' });
        }

        res.json(rows[0]);
    } catch (err) {
        console.error(err);

        // Handle duplicate email error
        if (err.code === '23505') {
            return res.status(409).json({ error: 'Email already exists' });
        }

        res.status(500).send('Server error');
    }
});

/**
 * DELETE /api/users/:id
 * Delete a user by ID.
 */
router.delete('/users/:id', async (req, res) => {
    const { id } = req.params;

    try {
        const { rowCount } = await pool.query('DELETE FROM users WHERE id = $1', [id]);

        if (rowCount === 0) {
            return res.status(404).json({ error: 'users not found' });
        }

        res.status(204).send();
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

// Export the router
module.exports = router;
