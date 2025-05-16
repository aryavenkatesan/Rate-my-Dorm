const asyncHandler = require ("express-async-handler")
const Listing = require("../models/listingModel")

//@desc Make new Sublease
//@route POST /api/listing
//@access public <- not best practice but im going fast
const createListing = asyncHandler(async (req, res) => {
    const { UUID, username, name, address, price, distance, propertyType, contactEmail, phoneNumber, rating, comments, school } = req.body;
    console.log("StartedAPI")
    if (!UUID || !username || !name || !address || !price || !distance || !propertyType || !contactEmail || !phoneNumber || !school ){
        res.status(400);
        console.log("fields error")
        throw new Error("All fields are required");
    }
    if (!comments) {
        comments = "No comments"
    }
    if (!rating) {
        rating = 0
    }
    
    console.log("after input val")
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
        school
    });
    console.log("Made listing and returning")
    res.status(201).json(req.body);
});

//@desc Get all listings
//@route GET /api/listing
//@access public <- not best practice but im going fast
const getListings = asyncHandler(async (req, res) => {
    const contacts = await Listing.find( {} );
    res.status(200).json({ contacts });
});

//@desc Delete a listing
//@route DELETE /api/listing
//@access public <- not best practice but im going fast
const deleteListing = asyncHandler(async (req, res) => {
    const { UUID } = req.body;
    if (!UUID){
        res.status(400);
        throw new Error("UUID Required.");
    }
    
    const listing = await Listing.findOneAndDelete({ UUID: UUID });
    
    if (!listing) { 
        res.status(404);
        throw new Error("Listing not found");
    }

    res.status(200).json({ message: "Listing deleted successfully", deletedListing: listing });

});

//@desc alternate heart placements  
//@route PUT /api/listing/
//@access public <- not best practice but im going fast
const addHeart = asyncHandler(async (req, res) => {
    console.log("Started")
    const { UUID, username } = req.body;
    if (!UUID || !username){
        res.status(400);
        throw new Error("Username and list required.");
    }
    
    const listing = await Listing.findOne( {UUID: UUID} );
    if(!listing) { 
        res.status(404)
        throw new Error("Listing not found")
    }
    if (!listing.heartList.includes(username)) {
        //add if its not there
        listing.heartList.push(username);
    } else {
        //remove if it is there
        const heartIndex = listing.heartList.indexOf(username);
        listing.heartList.splice(heartIndex, 1);
    }

    //save changes to db
    const updatedListing = await listing.save();
    console.log("added heart")

    res.status(200).json(updatedListing);
});

module.exports = { createListing, getListings, addHeart, deleteListing }
