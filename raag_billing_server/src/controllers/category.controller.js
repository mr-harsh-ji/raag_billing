const CategoryModel = require('../models/category.model');

async function getCategories(req, res, next) {
  try {
    const categories = await CategoryModel.findAllByUserId(req.user.id);
    return res.json({ success: true, data: categories });
  } catch (error) {
    next(error);
  }
}

async function createCategory(req, res, next) {
  try {
    const { name, description } = req.body;
    if (!name || name.trim().length === 0) {
      return res.status(400).json({ success: false, message: 'Category name is required' });
    }
    const newCategory = await CategoryModel.create(req.user.id, { name, description });
    return res.status(201).json({ success: true, data: newCategory });
  } catch (error) {
    next(error);
  }
}

async function updateCategory(req, res, next) {
  try {
    const { id } = req.params;
    const { name, description } = req.body;
    if (!name || name.trim().length === 0) {
      return res.status(400).json({ success: false, message: 'Category name is required' });
    }
    const updated = await CategoryModel.update(req.user.id, id, { name, description });
    if (!updated) {
      return res.status(404).json({ success: false, message: 'Category not found' });
    }
    return res.json({ success: true, data: updated });
  } catch (error) {
    next(error);
  }
}

async function deleteCategory(req, res, next) {
  try {
    const { id } = req.params;
    const deleted = await CategoryModel.delete(req.user.id, id);
    if (!deleted) {
      return res.status(404).json({ success: false, message: 'Category not found' });
    }
    return res.json({ success: true, message: 'Category deleted successfully' });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
};
