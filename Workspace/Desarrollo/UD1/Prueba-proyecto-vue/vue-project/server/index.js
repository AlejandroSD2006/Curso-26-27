import express from "express";
import cors from "cors";
import dotenv from "dotenv";


dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.post("/api/rutina", async (req, res) => {
  const { tipo, objetivo, dias } = req.body;

  const prompt = `Crea una rutina de entrenamiento de ${tipo} para ganar ${objetivo}, entrenando ${dias} días a la semana. Devuelve la rutina detallada en español, con ejercicios, series y repeticiones.`;

  try {
    const response = await fetch(
      "https://openrouter.ai/api/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`,
          "HTTP-Referer": "http://localhost:5173",
        },
        body: JSON.stringify({
          model: 'meta-llama/llama-3.3-70b-instruct',
          messages: [{ role: "user", content: prompt }],
        }),
      },
    );

    const data = await response.json();

    if (!response.ok) {
      const message = data?.error?.message || data?.message || `HTTP ${response.status}`;
      console.error("Error de OpenRouter:", response.status, message);
      return res.status(502).json({ error: `Error de OpenRouter: ${message}` });
    }

    const respuesta = data?.choices?.[0]?.message?.content;
    if (typeof respuesta !== "string" || !respuesta.trim()) {
      console.error("OpenRouter devolvió una respuesta sin contenido válido.");
      return res.status(502).json({ error: "OpenRouter devolvió una respuesta sin contenido válido." });
    }

    res.json({ respuesta });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al generar la rutina" });
  }
});

app.listen(3000, () => {
  console.log("API escuchando en http://localhost:3000");
});
