const asyncHandler = require ("express-async-handler")
const Listing = require("../models/listingModel")

//@desc Make new Sublease
//@route POST /api/listing
//@access public <- not best practice but im going fast
const createListing = asyncHandler(async (req, res) => {
    const { UUID, username, name, address, price, distance, propertyType, contactEmail} = req.body;
    if (!UUID || !username || !name || !address || !price || !distance || !propertyType || !contactEmail){
        res.status(400);
        throw new error("All fields are required");
    }
    const listing = await Listing.create({
        UUID,
        username,
        name,
        address,
        price,
        distance,
        propertyType,
        contactEmail
    });
    //console.log("Request body is: ", req.body);
    res.status(201).json(req.body);
});

//@desc Get all listings
//@route GET /api/listing
//@access public <- not best practice but im going fast
const getListings = asyncHandler(async (req, res) => {
    const contacts = await Listing.find( {} );
    res.status(200).json({ contacts });
});

//@desc alternate heart placements  
//@route PUT /api/listing/
//@access public <- not best practice but im going fast
const addHeart = asyncHandler(async (req, res) => {
    const { username, UUID } = req.body;
    if (!username || !UUID){
        res.status(400);
        throw new error("Username and list required.");
    }
    const listing = await Listing.findOne( { UUID: UUID } );
    if(!listing) { 
        res.status(404)
        throw new Error("Listing not found")
    }

    if (!listing.heartList.includes(username)) {
        //add if its not there
        listing.heartList.push(username);
    } else {
        //remove if it is there
        console.log("c4")
        listing.heartList.splice(listing.heartIndex, 1);
    }

    //save changes to db
    const updatedListing = await listing.save();

    res.status(200).json({updatedListing});
});

module.exports = { createListing, getListings, addHeart }