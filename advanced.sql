db.books.aggregate([{
    $project: { 
        _id:1,
        title: "$title",
        price: "$price", 
        promo:{
        $cond: { if : {$lt:["$price", 60000]},
        then: '1%', else:{
            $cond: {if:{$and:[{$lt:["$price", 90000]}, {$gt:["$price", 60000]}]}, 
            then: '2%', else: '3%'
        } }
    }}}
}])