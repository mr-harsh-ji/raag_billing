const BusinessProfileModel = require('../models/business_profile.model');

/**
 * Get Business Profile
 * GET /api/business-profile
 */
async function getProfile(req, res, next) {
  try {
    const userId = req.user.id;
    let profile = await BusinessProfileModel.findByUserId(userId);

    if (!profile) {
      // Auto-create default profile if missing
      profile = await BusinessProfileModel.upsert(userId, {
        business_name: `${req.user.name}'s Business`,
        owner_name: req.user.name,
        email: req.user.email,
        phone: req.user.phone,
      });
    }

    return res.json({
      success: true,
      data: profile,
    });
  } catch (error) {
    next(error);
  }
}

/**
 * Create or Update Business Profile
 * PUT /api/business-profile
 * POST /api/business-profile
 */
async function updateProfile(req, res, next) {
  try {
    const userId = req.user.id;
    const { business_name } = req.body;

    if (business_name !== undefined && business_name.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Business name cannot be empty.',
      });
    }

    const updatedProfile = await BusinessProfileModel.upsert(userId, req.body);

    return res.json({
      success: true,
      data: updatedProfile,
      message: 'Business profile saved successfully.',
    });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  getProfile,
  updateProfile,
};
