const express = require('express');
const router = express.Router();
const stockMovementController = require('../controllers/stock_movement.controller');
const authenticateToken = require('../middleware/auth.middleware');

router.use(authenticateToken);

router.get('/', stockMovementController.getStockMovements);

module.exports = router;
