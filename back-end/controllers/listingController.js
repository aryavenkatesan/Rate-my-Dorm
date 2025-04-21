const asyncHandler = require ("express-async-handler")
const Listing = require("../models/listingModel")

//@desc Make new Sublease
//@route POST /api/listing
//@access public <- not best practice but im going fast
const createListing = asyncHandler(async (req, res) => {
    const { UUID, username, name, address, price, distance, propertyType, contactEmail, phoneNumber, rating, comments } = req.body;
    if (!UUID || !username || !name || !address || !price || !distance || !propertyType || !contactEmail || !phoneNumber || !rating){
        res.status(400);
        console.log("here")
        throw new error("All fields are required");
    }
    if (!comments) {
        comments = "No comments"
    }
    
    console.log("Here")
    const listing = await Listing.create({
        UUID,
        username,
        name,
        address,
        price,
        distance,
        propertyType,
        contactEmail,
        heartList : [""],
        phoneNumber,
        rating,
        comments,
    });
    res.status(201).json(req.body);
});

//@desc Get all listings
//@route GET /api/listing
//@access public <- not best practice but im going fast
const getListings = asyncHandler(async (req, res) => {
    const contacts = await Listing.find( {} );
    console.log("Attempted get")
    res.status(200).json({ contacts });
});

//@desc alternate heart placements  
//@route PUT /api/listing/:id
//@access public <- not best practice but im going fast
const addHeart = asyncHandler(async (req, res) => {
    const { username } = req.body;
    if (!username){
        res.status(400);
        throw new error("Username and list required.");
    }
    const listing = await Listing.findById(req.params.id);
    if(!listing) { 
        res.status(404)
        throw new Error("Listing not found")
    }
    if (!listing.heartList.includes(username)) {
        //add if its not there
        listing.heartList.push(username);
    } else {
        //remove if it is there
        listing.heartList.splice(heartIndex, 1);
    }

    //save changes to db
    const updatedListing = await listing.save();

    res.status(200).json(updatedContact);
});

module.exports = { createListing, getListings, addHeart }