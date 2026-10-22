const ProductModel = require('../models/product.model');

async function getProducts(req, res, next) {
  try {
    const { search, category_id, barcode } = req.query;
    const products = await ProductModel.findAllByUserId(req.user.id, {
      search,
      category_id,
      barcode,
    });
    return res.json({ success: true, count: products.length, data: products });
  } catch (error) {
    next(error);
  }
}

async function getProductById(req, res, next) {
  try {
    const { id } = req.params;
    const product = await ProductModel.findById(req.user.id, id);
    if (!product) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    return res.json({ success: true, data: product });
  } catch (error) {
    next(error);
  }
}

async function createProduct(req, res, next) {
  try {
    const { name } = req.body;
    if (!name || name.trim().length === 0) {
      return res.status(400).json({ success: false, message: 'Product name is required' });
    }
    const newProduct = await ProductModel.create(req.user.id, req.body);
    return res.status(201).json({ success: true, data: newProduct });
  } catch (error) {
    next(error);
  }
}

async function updateProduct(req, res, next) {
  try {
    const { id } = req.params;
    const updated = await ProductModel.update(req.user.id, id, req.body);
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    return res.json({ success: true, data: updated });
  } catch (error) {
    next(error);
  }
}

async function deleteProduct(req, res, next) {
  try {
    const { id } = req.params;
    const deleted = await ProductModel.delete(req.user.id, id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Product not found' });
    }
    return res.json({ success: true, message: 'Product deleted successfully' });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
};
