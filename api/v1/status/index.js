<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<title>Status Board</title>

<style>
    body {
        background: #0f0f0f;
        color: white;
        font-family: Arial;
        padding: 20px;
    }

    .box {
        max-width: 500px;
        margin: auto;
        background: #161616;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 0 10px #000;
    }

    .legend {
        font-size: 14px;
        margin-bottom: 15px;
        line-height: 1.6;
    }

    .line {
        border-bottom: 1px solid #333;
        margin: 10px 0;
    }

    .item {
        display: flex;
        justify-content: space-between;
        padding: 8px 0;
        font-size: 15px;
    }

    .name {
        color: #ddd;
    }

    .status {
        font-size: 18px;
    }

    .working { color: #00ff6a; }
    .broken { color: #ff3b3b; }
    .dev { color: #ffb400; }
    .new { color: #4da3ff; }
</style>
</head>

<body>

<div class="box">

    <!-- 🔝 Legend -->
    <div class="legend">
        🟢 = ใช้งานได้<br>
        🔴 = ใช้ไม่ได้<br>
        🛠️ = กำลังปรับปรุง<br>
        📌 = เพิ่มมาใหม่
    </div>

    <div class="line"></div>

    <!-- 🔽 List -->
    <div id="list"></div>

</div>

<script>
const games = [
    {name: "[FPS] Flick", status: "working"},
    {name: "Build a Boat For Treasure", status: "dev"},
    {name: "Murder Mystery 2", status: "working"},
    {name: "[FPS] Gun GroundsFFA", status: "working"},
    {name: "Blox Fruit", status: "new"},
    {name: "Die of Deathians", status: "broken"}
];

const icon = {
    working: "🟢",
    broken: "🔴",
    dev: "🛠️",
    new: "📌"
};

const list = document.getElementById("list");

function render() {
    list.innerHTML = "";

    games.forEach(g => {
        const div = document.createElement("div");
        div.className = "item";

        div.innerHTML = `
            <div class="name">${g.name}</div>
            <div class="status">${icon[g.status]}</div>
        `;

        list.appendChild(div);
    });
}

render();
</script>

</body>
</html>
