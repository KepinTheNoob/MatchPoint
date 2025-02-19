import { PrismaClient } from '@prisma/client/edge';
import { withAccelerate } from '@prisma/extension-accelerate';
import express from 'express';

const prisma = new PrismaClient().$extends(withAccelerate());
const router = express.Router();

const validateEmail = (email) => {
const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
return re.test(String(email).toLowerCase());
};

router.get('/', async (req, res) => {
try {
    const users = await prisma.user.findMany();
    res.json(users);
} catch (error) {
    res.status(500).json({ error: 'Failed to fetch users' });
}
});

router.post('/', async (req, res) => {
const { name, email, password } = req.body;

if (!validateEmail(email)) {
    return res.status(400).json({ error: 'Invalid email format' });
}

try {
    const existingUser = await prisma.user.findUnique({
    where: { email },
    });

    if (existingUser) {
    return res.status(400).json({ error: 'Email already exists' });
    }

    const user = await prisma.user.create({
    data: { name, email, password },
    });
    res.json(user);
} catch (error) {
    res.status(500).json({ error: 'Failed to create user' });
}
});

export default router;