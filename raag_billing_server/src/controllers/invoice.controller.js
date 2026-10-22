const InvoiceModel = require('../models/invoice.model');

async function getInvoices(req, res, next) {
  try {
    const invoices = await InvoiceModel.findAllByUserId(req.user.id);
    return res.json({ success: true, count: invoices.length, data: invoices });
  } catch (error) {
    next(error);
  }
}

async function getInvoiceById(req, res, next) {
  try {
    const { id } = req.params;
    const invoice = await InvoiceModel.findById(req.user.id, id);
    if (!invoice) {
      return res.status(404).json({ success: false, message: 'Invoice not found' });
    }
    return res.json({ success: true, data: invoice });
  } catch (error) {
    next(error);
  }
}

async function createInvoice(req, res, next) {
  try {
    const { customer_id, customerId, items } = req.body;
    if (!customer_id && !customerId) {
      return res.status(400).json({ success: false, message: 'Customer ID is required' });
    }
    if (!Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ success: false, message: 'At least one invoice item is required' });
    }

    const newInvoice = await InvoiceModel.create(req.user.id, req.body);
    return res.status(201).json({ success: true, data: newInvoice });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getInvoices,
  getInvoiceById,
  createInvoice,
};
