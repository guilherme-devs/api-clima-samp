const express = require('express');
const axios = require('axios');
const app = express();
const PORT = 3000;

const CLOUD_MAP = {
  'clear_day': 10,     // Ensolarado
  'clear_night': 11,   // Noite Limpa
  'cloud': 4,          // Nublado
  'cloudly_day': 15,   // Sol com nuvens
  'rain': 8,           // Chuva
  'storm': 8,          // Tempestade
  'fog': 9             // Neblina
};

app.get('/weather-sync', async (req, res) => {
  try {
    const response = await axios.get('https://api.hgbrasil.com/weather?key=73f5b369&city_name=Los%20Angeles,CA');
    const data = response.data.results;
    
    const sampWeather = CLOUD_MAP[data.condition_slug] || 1; 
    const [hour] = data.time.split(':').map(Number);

    const payload = `${sampWeather},${hour},${data.temp},${data.description}`;
    
    res.send(payload); 
  } catch (error) {
    res.status(500).send("0,0,0,Erro");
  }
});

app.listen(PORT, () => console.log(`API Rodando na porta ${PORT}`));