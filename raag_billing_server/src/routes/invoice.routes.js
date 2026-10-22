const express = require('express');
const router = express.Router();
const invoiceController = require('../controllers/invoice.controller');
const authenticateToken = require('../middleware/auth.middleware');

router.use(authenticateToken);

router.get('/', invoiceController.getInvoices);
router.get('/:id', invoiceController.getInvoiceById);
router.post('/', invoiceController.createInvoice);

module.exports = router;
