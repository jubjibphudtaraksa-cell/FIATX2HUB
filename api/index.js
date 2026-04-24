<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Status Board</title>

<style>
body {
    background:#0d0d0d;
    color:white;
    font-family:Arial;
    display:flex;
    justify-content:center;
    padding-top:40px;
}

.box {
    width:500px;
    background:#1a1a1a;
    padding:20px;
    border-radius:12px;
}

.legend {
    font-size:14px;
    margin-bottom:10px;
    line-height:1.6;
}

.item {
    display:flex;
    justify-content:space-between;
    padding:8px 0;
    border-bottom:1px solid #333;
}

.name {
    color:#ddd;
}

.status {
    font-size:18px;
}
</style>
</head>

<body>

<div class="box">

<div class="legend">
🟢 ใช้งานได้<br>
🔴 ใช้ไม่ได้<br>
🛠️ ปรับปรุง<br>
📌 เพิ่มใหม่
</div>

<div id="list"></div>

</div>

<script>

const icon = {
    working: "🟢",
    broken: "🔴",
    dev: "🛠️",
    new: "📌"
};

async function load(){
    const res = await fetch("/api/games");
    const data = await res.json();

    const list = document.getElementById("list");
    list.innerHTML = "";

    data.forEach(g => {
        const div = document.createElement("div");
        div.className = "item";

        div.innerHTML = `
            <div class="name">${g.name}</div>
            <div class="status">${icon[g.status]}</div>
        `;

        list.appendChild(div);
    });
}

load();
setInterval(load, 5000);

</script>

</body>
</html>
