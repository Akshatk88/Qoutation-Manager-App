const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");



// REGISTER

exports.register = async(req,res)=>{


try{


const {
username,
email,
password
}=req.body;



const userExist =
await User.findOne({email});



if(userExist){

return res.status(400).json({

success:false,

message:"User already exists"

});

}



const hashPassword =
await bcrypt.hash(password,10);



const user =
await User.create({

username,

email,

password:hashPassword

});



res.status(201).json({

success:true,

message:"Registration successful",

user:{

id:user._id,

username:user.username,

email:user.email

}

});


}

catch(error){


res.status(500).json({

success:false,

message:error.message

});


}


};





// LOGIN

exports.login = async(req,res)=>{


try{


const {
email,
password
}=req.body;



const user =
await User.findOne({
email
});



if(!user){

return res.status(400).json({

success:false,

message:"Invalid email"

});

}




const isMatch =
await bcrypt.compare(
password,
user.password
);



if(!isMatch){


return res.status(400).json({

success:false,

message:"Invalid password"

});


}




const token =
jwt.sign(

{
id:user._id
},

process.env.JWT_SECRET,

{
expiresIn:"7d"
}

);



res.status(200).json({

success:true,

token,


user:{

id:user._id,

username:user.username,

email:user.email

}


});



}

catch(error){


res.status(500).json({

success:false,

message:error.message

});


}


};