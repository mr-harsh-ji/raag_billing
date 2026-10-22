const express = require('express');
const router = express.Router();
const businessProfileController = require('../controllers/business_profile.controller');
const authenticateToken = require('../middleware/auth.middleware');

// All Business Profile routes require JWT authentication
router.use(authenticateToken);

router.get('/', businessProfileController.getProfile);
router.put('/', businessProfileController.updateProfile);
router.post('/', businessProfileController.updateProfile);

module.exports = router;
