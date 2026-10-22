const PurchaseModel = require('../models/purchase.model');

async function getPurchases(req, res, next) {
  try {
    const purchases = await PurchaseModel.findAllByUserId(req.user.id);
    return res.json({ success: true, count: purchases.length, data: purchases });
  } catch (error) {
    next(error);
  }
}

async function createPurchase(req, res, next) {
  try {
    const newPurchase = await PurchaseModel.create(req.user.id, req.body);
    return res.status(201).json({ success: true, data: newPurchase });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getPurchases,
  createPurchase,
};
