const asyncHandler = require ("express-async-handler");
const User = require("../models/userModel");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

//@desc Register a user
//@router POST /api/users/register
//@access public
const registerUser = asyncHandler(async (req, res) => {
    const { username, school, password } = req.body;
    if (!username || !school || !password) {
        res.status(400);
        throw new Error("All fields are mandatory!");
    }
    const userNotAvailable = await User.findOne({ username });
    if (userNotAvailable) {
        res.status(400);
        throw new Error("username has been taken")
    }

    //Hash password
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const user = await User.create({
        username,
        school,
        password: hashedPassword,
    })
    if(user) {
        res.status(201).json( { _id: user.id, email: user.email });
    } else {
        res.status(400);
        throw new Error("User data was not valid");
    }
    res.json({ message: "Register the user" })
});

//@desc Login a user
//@router POST /api/users/login 
//@access public
const loginUser = asyncHandler(async (req, res) => {
    const { username, password } = req.body;
    if (!username || !password) {
        res.status(400);
        throw new Error("All fields are mandatory");
    }
    const user = await User.findOne({ username });

    //compare password with hashedpassword
    if (user && (await bcrypt.compare(password, user.password))) {
        const accessToken = jwt.sign({
            user: {
                username: user.username,
                school: user.school,
                id: user.id,
            },
        }, 
        process.env.ACCESS_TOKEN_SECRET,
        {expiresIn: "30m"}
    );
        res.status(200).json({ 
            accessToken,
            _id: user.id,
        });
    } else {
        res.status(401);
        throw new Error("Invalid username or password")
    }
    res.json({ message: "Login the user" })
});

//@desc Current user info
//@router GET /api/users/current
//@access private
const currentUser = asyncHandler(async (req, res) => {
    res.json(req.user);
});

module.exports = { registerUser, loginUser, currentUser}