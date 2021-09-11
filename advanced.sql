--1
db.books.find(
    {$or:[{authorID:1}, {authorID:2}]}
);

--2
db.books.aggregate([
    {$project:{ 
        title:1, 
        authorID:1 
        price:1}},
    {$match:{
        authorID:1}}
]);

--3
db.books.aggregate(
    {$match:{authorID:2}},
    {$group:{
        _id:"$authorID",
        totalPages:
        {$sum:"$stats.page"}
    }}
);

--4
db.books.aggregate([
    {$lookup:{ 
        from: "authors", 
        localField:"authorID", 
        foreignField: "_id", 
        as:"author" }}
]);

db.books.aggregate([{ 
    $lookup:{ from: "authors", 
    localField:"authorID", 
    foreignField: "_id", as:"books" }}, 
    { $lookup:{ 
        from: "publishers", 
        localField:"publisherID", 
        foreignField: "_id", 
        as:"publisher" }}
]);

--5
db.authors.aggregate([
    {$lookup:{ 
        from:"books", 
        localField:"_id", 
        foreignField:"authorID", 
        as:"books" }},
    {$lookup:{ 
        from:"publisher", 
        localField:"publisherID", 
        foreignField:"_id", as:"publisher" }},
    {$project:{ 
        _id:{$concat:["$firstName", " ", "$lastName"]},
        number_of_books:{$size:"$books"},
        list_of_books:"$books.title"}}]);

--6
db.authors.aggregate([
    {$lookup: { 
        from:"books", 
        localField:"_id", 
        foreignField:"authorID", 
        as:"books" }},   
    {$lookup:{ 
        from:"publishers", 
        localField:"books.publisherID", 
        foreignField:"_id", 
        as:"publishers" }},
    {$project:{
        _id:{$concat:["$firstName", " ", "$lastName"]}, 
        number_of_books:{$size:"$books"},
        list_of_books:{$concatArrays: ["$books.title", "$publishers.publisherName"]},
    }}, 
]);
   
--7
db.books.aggregate([
    {$project: { 
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
}]);

--8
db.books.aggregate([
    {$lookup: { 
        from:"authors", 
        localField:"authorID", 
        foreignField:"_id", 
        as:"authors" 
    }},
    {$lookup:{ 
        from:"publishers", 
        localField:"publisherID", 
        foreignField:"_id", 
        as:"publishers" 
    }},
    {$unwind: "$authors"},
    {$unwind: "$publishers"},
    {$project: { 
        _id:0,
        title: "$title",
        price: "$price", 
        publisher: "$publishers.publisherName",
        author:{$concat:["$authors.firstName", " ", "$authors.lastName"]}, 
    }},
    { "$sort": { "price": -1 } },
]);

--9
db.books.aggregate([
    {$lookup:{ 
        from:"publishers", 
        localField:"publisherID", 
        foreignField:"_id", 
        as:"publishers" 
    }},
    {$unwind: "$publishers"},
    {$project: { 
        _id:1,
        title: "$title",
        price: "$price", 
        publisher: "$publishers.publisherName",
    }},
]);

db.books.aggregate([
    {$lookup:{ 
        from:"publishers", 
        localField:"publisherID", 
        foreignField:"_id", 
        as:"publishers" 
    }},
    {$unwind: "$publishers"},
    {$match: { $or: [{_id:3 }, {_id:4}]}},
    {$project: { 
        _id:1,
        title: "$title",
        price: "$price", 
        publisher: "$publishers.publisherName",
    }},
]);