const CustomerModel = require('../models/customer.model');

async function getCustomers(req, res, next) {
  try {
    const { search } = req.query;
    const customers = await CustomerModel.findAllByUserId(req.user.id, search);
    return res.json({ success: true, count: customers.length, data: customers });
  } catch (error) {
    next(error);
  }
}

async function getCustomerById(req, res, next) {
  try {
    const { id } = req.params;
    const customer = await CustomerModel.findById(req.user.id, id);
    if (!customer) {
      return res.status(404).json({ success: false, message: 'Customer not found' });
    }
    return res.json({ success: true, data: customer });
  } catch (error) {
    next(error);
  }
}

async function createCustomer(req, res, next) {
  try {
    const { name } = req.body;
    if (!name || name.trim().length === 0) {
      return res.status(400).json({ success: false, message: 'Customer name is required' });
    }
    const newCustomer = await CustomerModel.create(req.user.id, req.body);
    return res.status(201).json({ success: true, data: newCustomer });
  } catch (error) {
    next(error);
  }
}

async function updateCustomer(req, res, next) {
  try {
    const { id } = req.params;
    const updated = await CustomerModel.update(req.user.id, id, req.body);
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Customer not found' });
    }
    return res.json({ success: true, data: updated });
  } catch (error) {
    next(error);
  }
}

async function deleteCustomer(req, res, next) {
  try {
    const { id } = req.params;
    const deleted = await CustomerModel.delete(req.user.id, id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Customer not found' });
    }
    return res.json({ success: true, message: 'Customer deleted successfully' });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getCustomers,
  getCustomerById,
  createCustomer,
  updateCustomer,
  deleteCustomer,
};
