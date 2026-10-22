const express = require('express');
const router = express.Router();
const purchaseController = require('../controllers/purchase.controller');
const authenticateToken = require('../middleware/auth.middleware');

router.use(authenticateToken);

router.get('/', purchaseController.getPurchases);
router.post('/', purchaseController.createPurchase);

module.exports = router;
