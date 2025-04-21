const express = require("express");
const { createListing, getListings, addHeart } = require("../controllers/listingController")
const router = express.Router();

router.route("/").post(createListing).get(getListings).put(addHeart);

module.exports = router;