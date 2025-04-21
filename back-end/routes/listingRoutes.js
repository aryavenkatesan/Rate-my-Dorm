const express = require("express");
const { createListing, getListings, addHeart, deleteListing } = require("../controllers/listingController")
const router = express.Router();

router.route("/").post(createListing).get(getListings).put(addHeart).delete(deleteListing);

module.exports = router;