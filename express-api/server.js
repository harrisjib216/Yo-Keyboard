const express = require('express')
const bodyParser = require('body-parser');
const cors = require('cors');

const translate = require('@iamtraction/google-translate');

const app = express();
const port = 3000;

app.use(cors());

// Configuring body parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post('/translate', async (req, res) => {
    const body = req.body[0];

    try {
        console.log(req.body[0].text);
        const translation = await translate(body.text, {
            from: body.from,
            to: body.to
        });
        
        console.log(translation);
        res.send({"res": translation.text || ""});
    } catch (error) {
        console.error(error);
        res.status(400).send({"error": "bad request"});
    }
});

app.listen(port, () => console.log(`Translation API: localhost:${port}`));
