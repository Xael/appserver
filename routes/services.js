const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const { protect, adminOnly } = require('../middleware/auth');
const prisma = new PrismaClient();

// Get all services
router.get('/', protect, async (req, res) => {
  try {
    const services = await prisma.service.findMany({ orderBy: { name: 'asc' } });
    res.json(services);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching services', error: error.message });
  }
});

// Create a new service
router.post('/', protect, adminOnly, async (req, res) => {
  const { name, unit } = req.body;
  try {
    const newService = await prisma.service.create({
      data: { name, unit },
    });
    res.status(201).json(newService);
  } catch (error) {
    res.status(500).json({ message: 'Error creating service', error: error.message });
  }
});

// Update a service
router.put('/:id', protect, adminOnly, async (req, res) => {
  const { name, unit } = req.body;
  try {
    const updatedService = await prisma.service.update({
      where: { id: parseInt(req.params.id) },
      data: { name, unit },
    });
    res.json(updatedService);
  } catch (error) {
    res.status(500).json({ message: 'Error updating service', error: error.message });
  }
});

// Delete a service
router.delete('/:id', protect, adminOnly, async (req, res) => {
  try {
    await prisma.service.delete({
      where: { id: parseInt(req.params.id) },
    });
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ message: 'Error deleting service', error: error.message });
  }
});

module.exports = router;
