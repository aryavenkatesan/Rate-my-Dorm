const mongoose = require("mongoose")

const listingSchema = mongoose.Schema({
    UUID: { //stringify within swift
        type: String,
        required: true,
    },
    username: {
        type: String,
        //ref: "User",
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    address: {
        type: String,
        required: true,
    },
    price: {
        type: Number, // Use Number for doubles in Mongoose
        required: true,
    },
    distance: {
        type: Number, // Use Number for doubles in Mongoose
        required: true,
    },
    propertyType: {
        type: String,
        enum: [".apartment", ".dorm", ".house"], // Enforce allowed values
        required: true,
    },
    contactEmail: {
        type: String,
        required: true,
    },
    heartList: {
        type: [String],
        required: false,
    },
    phoneNumber: {
        type: String,
        required: false,
    },
    rating: {
        type: Number,
        required: false,
    },
    comments: {
        type: String,
        required: false,
    },
    school: {
        type: String,
        required: false,
    }
});

module.exports = mongoose.model("Listing", listingSchema)
