<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Compatibility Chart — Blood Bridge</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f7f7f7;
            color: #333;
        }

        .navbar {
            background: #c0392b;
            color: white;
            padding: 14px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .navbar h1 { font-size: 20px; font-weight: 700; }
        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            opacity: 0.85;
            margin-left: 20px;
        }
        .navbar a:hover { opacity: 1; }

        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 700;
            color: #c0392b;
            margin-bottom: 4px;
        }
        .page-subtitle {
            font-size: 14px;
            color: #888;
            margin-bottom: 30px;
        }

        /* ---- Info cards ---- */
        .info-row {
            display: flex;
            gap: 14px;
            margin-bottom: 30px;
        }
        .info-card {
            flex: 1;
            background: white;
            border-radius: 12px;
            padding: 18px 20px;
            border: 1px solid #eee;
            text-align: center;
        }
        .info-icon { font-size: 28px; margin-bottom: 8px; }
        .info-title {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 4px;
            color: #222;
        }
        .info-desc {
            font-size: 12px;
            color: #999;
            line-height: 1.6;
        }

        /* ---- Compatibility grid ---- */
        .chart-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            border: 1px solid #eee;
            margin-bottom: 24px;
            overflow-x: auto;
        }
        .chart-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 18px;
            color: #222;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 500px;
        }
        th, td {
            padding: 12px 14px;
            text-align: center;
            font-size: 13px;
        }
        thead th {
            background: #c0392b;
            color: white;
            font-weight: 600;
            font-size: 13px;
        }
        thead th:first-child {
            border-radius: 8px 0 0 0;
            text-align: left;
            min-width: 120px;
        }
        thead th:last-child {
            border-radius: 0 8px 0 0;
        }
        tbody tr:nth-child(even) { background: #fafafa; }
        tbody tr:hover { background: #fdecea; }
        tbody td:first-child {
            font-weight: 700;
            color: #c0392b;
            text-align: left;
            font-size: 14px;
        }

        .check {
            color: #1e8449;
            font-size: 16px;
            font-weight: 700;
        }
        .cross {
            color: #ddd;
            font-size: 16px;
        }

        /* ---- Blood type cards ---- */
        .blood-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 24px;
        }
        .blood-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #eee;
            padding: 18px 14px;
            text-align: center;
            transition: all 0.2s;
            cursor: pointer;
        }
        .blood-card:hover {
            border-color: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(192,57,43,0.1);
        }
        .blood-card.selected {
            border-color: #c0392b;
            background: #fdecea;
        }
        .blood-type-big {
            font-size: 28px;
            font-weight: 700;
            color: #c0392b;
            margin-bottom: 6px;
        }
        .blood-label {
            font-size: 11px;
            color: #999;
            margin-bottom: 10px;
        }
        .blood-stat {
            font-size: 11px;
            color: #555;
            line-height: 1.8;
        }

        /* ---- Detail panel ---- */
        .detail-panel {
            background: white;
            border-radius: 12px;
            border: 1px solid #eee;
            padding: 22px;
            margin-bottom: 24px;
            display: none;
        }
        .detail-panel.show { display: block; }
        .detail-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 16px;
            color: #222;
        }
        .detail-row {
            display: flex;
            gap: 14px;
        }
        .detail-box {
            flex: 1;
            border-radius: 10px;
            padding: 16px;
        }
        .detail-box.can-give {
            background: #eafaf1;
            border: 1px solid #a9dfbf;
        }
        .detail-box.can-receive {
            background: #eaf4fd;
            border: 1px solid #a9cce3;
        }
        .detail-box-title {
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        .detail-box.can-give .detail-box-title { color: #1e8449; }
        .detail-box.can-receive .detail-box-title { color: #1a5276; }
        .type-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 7px;
        }
        .type-pill {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
        }
        .pill-green {
            background: #1e8449;
            color: white;
        }
        .pill-blue {
            background: #1a5276;
            color: white;
        }

        /* ---- Search by type button ---- */
        .btn-search-type {
            background: #c0392b;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 16px;
            transition: background 0.2s;
        }
        .btn-search-type:hover { background: #a93226; }

        .footer {
            text-align: center;
            padding: 30px;
            font-size: 12px;
            color: #bbb;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <h1>🩸 Blood Bridge</h1>
    <div>
        <a href="http://localhost:8081/searchDonors">🔍 Search Donors</a>
        <a href="http://localhost:8081/views/patient/compatibility.jsp">🩸 Compatibility Chart</a>
        <a href="#">📋 My Requests</a>
        <a href="http://localhost:8081/logout">🚪 Logout</a>
    </div>
</div>

<div class="container">

    <p class="page-title">Blood Compatibility Chart</p>
    <p class="page-subtitle">Find out which blood types are compatible for donation and transfusion</p>

    <!-- Info cards -->
    <div class="info-row">
        <div class="info-card">
            <div class="info-icon">⭐</div>
            <div class="info-title">Universal Donor</div>
            <div class="info-desc">O− can donate to all 8 blood types. Most valuable in emergencies.</div>
        </div>
        <div class="info-card">
            <div class="info-icon">💉</div>
            <div class="info-title">Universal Recipient</div>
            <div class="info-desc">AB+ can receive from all 8 blood types. Most flexible recipient.</div>
        </div>
        <div class="info-card">
            <div class="info-icon">⏳</div>
            <div class="info-title">Donation Gap</div>
            <div class="info-desc">Donors must wait 56 days between whole blood donations.</div>
        </div>
        <div class="info-card">
            <div class="info-icon">🏥</div>
            <div class="info-title">Always Verify</div>
            <div class="info-desc">Always confirm compatibility with a medical professional before transfusion.</div>
        </div>
    </div>

    <!-- Blood type cards -->
    <div class="chart-card">
        <p class="chart-title">Select a blood type to see compatibility details</p>
        <div class="blood-grid">
            <div class="blood-card" onclick="showDetail('A+')">
                <div class="blood-type-big">A+</div>
                <div class="blood-label">A Positive</div>
                <div class="blood-stat">Can give to: 2 types<br>Can receive from: 4 types</div>
            </div>
            <div class="blood-card" onclick="showDetail('A-')">
                <div class="blood-type-big">A−</div>
                <div class="blood-label">A Negative</div>
                <div class="blood-stat">Can give to: 4 types<br>Can receive from: 2 types</div>
            </div>
            <div class="blood-card" onclick="showDetail('B+')">
                <div class="blood-type-big">B+</div>
                <div class="blood-label">B Positive</div>
                <div class="blood-stat">Can give to: 2 types<br>Can receive from: 4 types</div>
            </div>
            <div class="blood-card" onclick="showDetail('B-')">
                <div class="blood-type-big">B−</div>
                <div class="blood-label">B Negative</div>
                <div class="blood-stat">Can give to: 4 types<br>Can receive from: 2 types</div>
            </div>
            <div class="blood-card" onclick="showDetail('O+')">
                <div class="blood-type-big">O+</div>
                <div class="blood-label">O Positive</div>
                <div class="blood-stat">Can give to: 4 types<br>Can receive from: 2 types</div>
            </div>
            <div class="blood-card" onclick="showDetail('O-')">
                <div class="blood-type-big">O−</div>
                <div class="blood-label">O Negative ⭐</div>
                <div class="blood-stat">Can give to: 8 types<br>Can receive from: 1 type</div>
            </div>
            <div class="blood-card" onclick="showDetail('AB+')">
                <div class="blood-type-big">AB+</div>
                <div class="blood-label">AB Positive 💉</div>
                <div class="blood-stat">Can give to: 1 type<br>Can receive from: 8 types</div>
            </div>
            <div class="blood-card" onclick="showDetail('AB-')">
                <div class="blood-type-big">AB−</div>
                <div class="blood-label">AB Negative</div>
                <div class="blood-stat">Can give to: 2 types<br>Can receive from: 4 types</div>
            </div>
        </div>
    </div>

    <!-- Detail panel -->
    <div class="detail-panel" id="detailPanel">
        <p class="detail-title" id="detailTitle"></p>
        <div class="detail-row">
            <div class="detail-box can-give">
                <div class="detail-box-title">✓ Can donate TO</div>
                <div class="type-pills" id="donateTo"></div>
            </div>
            <div class="detail-box can-receive">
                <div class="detail-box-title">✓ Can receive FROM</div>
                <div class="type-pills" id="receiveFrom"></div>
            </div>
        </div>
        <button class="btn-search-type" id="searchBtn" onclick="searchThisType()">
            Search donors with this blood type →
        </button>
    </div>

    <!-- Full compatibility table -->
    <div class="chart-card">
        <p class="chart-title">Full compatibility table</p>
        <table>
            <thead>
            <tr>
                <th>Donor \ Recipient</th>
                <th>A+</th>
                <th>A−</th>
                <th>B+</th>
                <th>B−</th>
                <th>O+</th>
                <th>O−</th>
                <th>AB+</th>
                <th>AB−</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>A+</td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
            </tr>
            <tr>
                <td>A−</td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
            </tr>
            <tr>
                <td>B+</td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
            </tr>
            <tr>
                <td>B−</td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
            </tr>
            <tr>
                <td>O+</td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
            </tr>
            <tr>
                <td>O− ⭐</td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
            </tr>
            <tr>
                <td>AB+</td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="cross">✗</span></td>
            </tr>
            <tr>
                <td>AB−</td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="cross">✗</span></td>
                <td><span class="check">✓</span></td>
                <td><span class="check">✓</span></td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="footer">
        Blood Bridge — Connecting donors with patients &nbsp;·&nbsp; Lifeline Coders © 2026
    </div>

</div>

<script>
    const compatibility = {
        'A+':  { donateTo: ['A+','AB+'],                        receiveFrom: ['A+','A-','O+','O-'] },
        'A-':  { donateTo: ['A+','A-','AB+','AB-'],             receiveFrom: ['A-','O-'] },
        'B+':  { donateTo: ['B+','AB+'],                        receiveFrom: ['B+','B-','O+','O-'] },
        'B-':  { donateTo: ['B+','B-','AB+','AB-'],             receiveFrom: ['B-','O-'] },
        'O+':  { donateTo: ['A+','B+','O+','AB+'],              receiveFrom: ['O+','O-'] },
        'O-':  { donateTo: ['A+','A-','B+','B-','O+','O-','AB+','AB-'], receiveFrom: ['O-'] },
        'AB+': { donateTo: ['AB+'],                             receiveFrom: ['A+','A-','B+','B-','O+','O-','AB+','AB-'] },
        'AB-': { donateTo: ['AB+','AB-'],                       receiveFrom: ['A-','B-','O-','AB-'] }
    };

    let selectedType = '';

    function showDetail(type) {
        selectedType = type;
        const data = compatibility[type];

        document.querySelectorAll('.blood-card').forEach(c => c.classList.remove('selected'));
        event.currentTarget.classList.add('selected');

        document.getElementById('detailTitle').textContent =
            'Blood type ' + type + ' — Compatibility details';

        document.getElementById('donateTo').innerHTML =
            data.donateTo.map(t => `<span class="type-pill pill-green">${t}</span>`).join('');

        document.getElementById('receiveFrom').innerHTML =
            data.receiveFrom.map(t => `<span class="type-pill pill-blue">${t}</span>`).join('');

        document.getElementById('detailPanel').classList.add('show');
        document.getElementById('detailPanel').scrollIntoView({ behavior: 'smooth' });
    }

    function searchThisType() {
        window.location.href =
            'http://localhost:8081/searchDonors?bloodType=' + selectedType;
    }
</script>

</body>
</html>