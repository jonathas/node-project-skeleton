export = (app) => {

    // Require the route files here

    app.get(process.env.API_BASE + "/", (req, res) => res.status(200).json({ message: "Welcome to the Skel project. Check the documentation for the list of available endpoints" }));

    // If no route is matched by now, it must be a 404
    app.use((req, res, next) => {
        res.status(404).json({ "error": "Endpoint not found" });
        next();
    });

    app.use((error, req, res, next) => {
        if (process.env.NODE_ENV === "production") {
            return res.status(500).json({ "error": "Unexpected error: " + error });
        }
        next(error);
    });

};
