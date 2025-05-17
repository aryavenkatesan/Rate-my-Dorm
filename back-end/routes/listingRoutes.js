const express = require("express");
const { createListing, getListings, addHeart, deleteListing } = require("../controllers/listingController")
const router = express.Router();
const validateToken = require("../middleware/validateTokenHandler");

router.use(validateToken);

router.route("/").get(getListings).delete(deleteListing);
router.route("/create").post(createListing)
router.route("/heart").put(addHeart);

module.exports = router;