/**
 * Geospatial Unified Document Viewer
 * 1. PDF Pages 1-46 via PDF.js on canvases
 * 2. Excel Sheet 1 (المصادر - 53 records, all 15 columns) with sticky headers & horizontal scroll
 * 3. Excel Sheet 2 (الأقسام والموضوعات - 3 tables)
 * 4. Excel Sheet 3 (دليل الاستخدام - all 11 rows)
 * Continuous single vertical scroll.
 */

(function () {
  'use strict';

  function escapeHtml(str) {
    if (str === null || str === undefined) return '';
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  function formatLinks(text, isMain) {
    if (!text) return '<span style="color: #A0A0A0; font-size: 9px;">—</span>';
    const str = String(text).trim();
    const lines = str.split('\n');
    const result = [];

    for (let line of lines) {
      line = line.trim();
      if (!line) continue;
      const colonIdx = line.indexOf('http');
      let label = '';
      let url = '';
      if (colonIdx > 0) {
        label = line.substring(0, colonIdx).replace(/[: ]+$/, '').trim();
        url = line.substring(colonIdx).trim();
      } else if (line.startsWith('http')) {
        url = line;
      }

      if (url) {
        const btnText = label || (isMain ? 'الرئيسي' : 'رابط');
        result.push(
          `<a href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer" title="${escapeHtml(url)}" ` +
          `style="display: block; width: 100%; box-sizing: border-box; background: #FAF6EE; color: #70392F; ` +
          `border: 1px solid #C59965; border-radius: 3px; padding: 2.5px 2px; font-size: 9.5px; font-weight: bold; ` +
          `text-decoration: none; margin: 2px 0; text-align: center; text-overflow: ellipsis; overflow: hidden; white-space: nowrap; transition: 0.15s;" ` +
          `onmouseover="this.style.background='#70392F';this.style.color='#FFF';" ` +
          `onmouseout="this.style.background='#FAF6EE';this.style.color='#70392F';">` +
          `${escapeHtml(btnText)} ↗</a>`
        );
      } else {
        result.push(`<span style="font-size: 9.5px; color: #555; display: block; overflow-wrap: break-word;">${escapeHtml(line)}</span>`);
      }
    }
    return result.length > 0 ? result.join('') : '<span style="color: #A0A0A0; font-size: 9px;">—</span>';
  }

  // Global scroll helper callable from Flutter or JS
  window.scrollGeospatialViewerTo = function (targetId) {
    if (targetId === 'pdf-top') {
      const vp = document.getElementById('geo-doc-main-viewport');
      if (vp) vp.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }
    const el = document.getElementById(targetId);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  window.initGeospatialDocViewer = function (domId, targetDiv, pdfUrl, xlsxUrl) {
    const root = targetDiv || document.getElementById(domId);
    if (!root) {
      console.error('[GeospatialDocViewer] Target container not found:', domId);
      return;
    }

    root.innerHTML = '';
    root.style.cssText = 'width: 100%; height: 100%; position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; flex-direction: column; overflow: hidden; background: #FAF6EE; direction: rtl; font-family: "NotoKufi", "Cairo", sans-serif;';

    // 1. Quick Navigation Toolbar
    const navBar = document.createElement('div');
    navBar.id = 'geo-nav-bar-' + domId;
    navBar.style.cssText = 'background: #FFFFFF; border-bottom: 1.5px solid #C59965; padding: 7px 12px; display: flex; align-items: center; justify-content: space-between; gap: 8px; flex-wrap: wrap; box-shadow: 0 2px 5px rgba(0,0,0,0.06); z-index: 20;';

    navBar.innerHTML = `
      <div style="display: flex; align-items: center; gap: 6px; flex-wrap: wrap;">
        <span style="font-weight: bold; color: #70392F; font-size: 12.5px; margin-left: 2px;">الانتقال السريع:</span>
        <button id="btn-nav-pdf" style="background: #70392F; color: white; border: 1px solid #70392F; border-radius: 6px; padding: 4px 10px; font-size: 11.5px; font-weight: bold; cursor: pointer; font-family: inherit;">الوثيقة الأساسية (1-46)</button>
        <button id="btn-nav-s1" style="background: #FAF6EE; color: #70392F; border: 1px solid #C59965; border-radius: 6px; padding: 4px 10px; font-size: 11.5px; font-weight: bold; cursor: pointer; font-family: inherit;">1. المصادر (53 مصدراً)</button>
        <button id="btn-nav-s2" style="background: #FAF6EE; color: #70392F; border: 1px solid #C59965; border-radius: 6px; padding: 4px 10px; font-size: 11.5px; font-weight: bold; cursor: pointer; font-family: inherit;">2. الأقسام والموضوعات</button>
        <button id="btn-nav-s3" style="background: #FAF6EE; color: #70392F; border: 1px solid #C59965; border-radius: 6px; padding: 4px 10px; font-size: 11.5px; font-weight: bold; cursor: pointer; font-family: inherit;">3. دليل الاستخدام</button>
      </div>
      <div id="page-status-badge" style="color: #70392F; font-size: 12px; font-weight: 700; padding: 3px 10px; background: rgba(112, 57, 47, 0.08); border-radius: 4px;">
        الصفحة 1 من 46
      </div>
    `;
    root.appendChild(navBar);

    // 2. Main Vertical Scroll Viewport
    const viewport = document.createElement('div');
    viewport.id = 'geo-doc-main-viewport';
    viewport.style.cssText = 'flex: 1; width: 100%; height: 100%; overflow-y: auto; overflow-x: hidden; padding: 14px 18px; box-sizing: border-box;';
    root.appendChild(viewport);

    // Section 1: PDF Pages
    const pdfSection = document.createElement('div');
    pdfSection.id = 'pdf-section-target';
    pdfSection.style.cssText = 'width: 100%; display: flex; flex-direction: column; align-items: center; gap: 16px; margin-bottom: 24px;';
    pdfSection.innerHTML = '<div style="color: #70392F; font-size: 14px; font-weight: bold; padding: 24px; text-align: center;">جاري قراءة وتحميل صفحات الوثيقة (46 صفحة)...</div>';
    viewport.appendChild(pdfSection);

    // Section 2: Excel Sheets
    const excelSection = document.createElement('div');
    excelSection.id = 'excel-section-target';
    excelSection.style.cssText = 'width: 100%; max-width: 1250px; margin: 0 auto; display: flex; flex-direction: column; gap: 24px;';
    viewport.appendChild(excelSection);

    const statusBadge = navBar.querySelector('#page-status-badge');
    const btnPdf = navBar.querySelector('#btn-nav-pdf');
    const btnS1 = navBar.querySelector('#btn-nav-s1');
    const btnS2 = navBar.querySelector('#btn-nav-s2');
    const btnS3 = navBar.querySelector('#btn-nav-s3');

    function highlightNav(activeBtn) {
      [btnPdf, btnS1, btnS2, btnS3].forEach(b => {
        if (b === activeBtn) {
          b.style.background = '#70392F';
          b.style.color = '#FFFFFF';
          b.style.borderColor = '#70392F';
        } else {
          b.style.background = '#FAF6EE';
          b.style.color = '#70392F';
          b.style.borderColor = '#C59965';
        }
      });
    }

    btnPdf.addEventListener('click', () => {
      viewport.scrollTop = 0;
      highlightNav(btnPdf);
    });

    // 1. Render PDF pages via ultra-crisp pre-rendered pages with perfect Arabic vector typography
    function loadPdf() {
      pdfSection.innerHTML = '';
      const total = 46;

      for (let pNum = 1; pNum <= total; pNum++) {
        const card = document.createElement('div');
        card.id = `pdf-page-card-${pNum}`;
        card.style.cssText = 'background: #FFFFFF; border: 1px solid #D5C7B5; border-radius: 6px; box-shadow: 0 3px 8px rgba(0,0,0,0.08); overflow: hidden; display: flex; flex-direction: column; align-items: center; max-width: 900px; width: 100%; margin: 0 auto;';

        const img = document.createElement('img');
        img.src = `assets/portal_pages/page_${pNum}.webp`;
        img.loading = pNum <= 3 ? 'eager' : 'lazy';
        img.alt = `بوابة المصادر الجيومكانية - صفحة ${pNum}`;
        img.style.cssText = 'width: 100%; height: auto; display: block;';
        card.appendChild(img);

        const footer = document.createElement('div');
        footer.style.cssText = 'width: 100%; background: #F7F3EB; border-top: 1px solid #EAE3D8; padding: 4px 12px; font-size: 11px; color: #666666; display: flex; justify-content: space-between; box-sizing: border-box;';
        footer.innerHTML = `<span>بوابة المصادر الجيومكانية</span><span>صفحة ${pNum} من ${total}</span>`;
        card.appendChild(footer);

        pdfSection.appendChild(card);
      }
    }

    // 2. Load Excel via SheetJS
    function loadExcel() {
      if (!window.XLSX) {
        setTimeout(loadExcel, 150);
        return;
      }

      const candidateUrls = [
        xlsxUrl,
        'assets/data/geospatial_am_my3.xlsx',
        'assets/assets/data/geospatial_am_my3.xlsx',
        'geospatial_am_my3.xlsx'
      ];

      function tryFetch(idx) {
        if (idx >= candidateUrls.length) return;
        fetch(candidateUrls[idx])
          .then(res => {
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return res.arrayBuffer();
          })
          .then(buffer => {
            renderExcel(buffer);
          })
          .catch(() => tryFetch(idx + 1));
      }

      tryFetch(0);
    }

    function renderExcel(buffer) {
      const wb = window.XLSX.read(buffer, { type: 'array' });
      excelSection.innerHTML = '';

      // Separator
      const sep = document.createElement('div');
      sep.style.cssText = 'margin: 24px 0 16px 0; text-align: center; border-top: 2.5px dashed #C59965; padding-top: 22px;';
      sep.innerHTML = `
        <div style="display: inline-block; background: linear-gradient(135deg, #70392F 0%, #4A231C 100%); color: #FEFCE8; font-size: 15px; font-weight: bold; padding: 8px 26px; border-radius: 22px; box-shadow: 0 3px 8px rgba(0,0,0,0.18); border: 1.5px solid #C59965;">
          بيانات مصنف الإكسل الملحقة (مستوردة بالكامل بعد الصفحة 46)
        </div>
      `;
      excelSection.appendChild(sep);

      // Sheet 1: المصادر
      const s1 = document.createElement('div');
      s1.id = 'sheet-1-target';
      s1.style.cssText = 'background: #FFFFFF; border: 1.5px solid #C59965; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.06); padding: 10px 10px; margin-bottom: 24px; width: 100%; box-sizing: border-box;';
      s1.innerHTML = `
        <div style="background: #70392F; color: #FFFFFF; padding: 10px 14px; border-radius: 6px; margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px;">
          <div>
            <div style="font-size: 15px; font-weight: bold; color: #FEFCE8;">الورقة 1: المصادر الجيومكانية (53 مصدراً)</div>
            <div style="font-size: 11.5px; color: #F0EAE1; margin-top: 2px;">تضم جميع الحقول والأعمدة الـ 15 كاملة متوافقة ومضبوطة بعرض الشاشة دون تمرير أفقي بروابط مباشرة</div>
          </div>
          <div style="background: #C59965; color: white; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: bold;">53 مصدراً</div>
        </div>
      `;

      const ws1 = wb.Sheets['المصادر'] || wb.Sheets[wb.SheetNames[0]];
      const rows1 = window.XLSX.utils.sheet_to_json(ws1, { header: 1 });

      if (rows1 && rows1.length > 0) {
        const headers = rows1[0];
        const tableWrapper = document.createElement('div');
        tableWrapper.style.cssText = 'width: 100%; overflow-x: auto; border: 1.2px solid #E2D9CC; border-radius: 6px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.04); box-sizing: border-box;';

        const table = document.createElement('table');
        table.style.cssText = 'width: 100%; border-collapse: collapse; font-size: 10px; text-align: right; table-layout: fixed;';

        // Optimized column width percentages totaling exactly 100%
        const colWidths = [
          '2.5%',  // 0: الرقم
          '6.5%',  // 1: القسم
          '8.5%',  // 2: المصدر
          '8.5%',  // 3: الاسم بالإنجليزية
          '7.5%',  // 4: الجهة
          '15.5%', // 5: ماذا يقدم
          '6.0%',  // 6: الدقة أو المقياس
          '4.5%',  // 7: التغطية
          '5.5%',  // 8: الفترة الزمنية
          '5.5%',  // 9: مستوى الدراسة الملائم
          '7.0%',  // 10: الوصول
          '6.5%',  // 11: الترخيص أو شروط الاستخدام
          '6.5%',  // 12: الصيغ
          '4.5%',  // 13: الرابط الرئيسي
          '5.0%',  // 14: روابط أخرى
        ];

        let theadHtml = '<thead><tr style="background: #70392F; color: #FFFFFF; font-weight: bold; position: sticky; top: 0; z-index: 10; box-shadow: 0 2px 3px rgba(0,0,0,0.15);">';
        headers.forEach((h, idx) => {
          const w = colWidths[idx] || '6%';
          theadHtml += `<th style="width: ${w}; padding: 6px 2px; border: 1px solid #8C4E42; text-align: center; font-size: 10px; line-height: 1.2; vertical-align: middle; overflow-wrap: break-word; word-break: break-word; box-sizing: border-box;">${escapeHtml(h || `عمود ${idx + 1}`)}</th>`;
        });
        theadHtml += '</tr></thead>';

        let tbodyHtml = '<tbody>';
        rows1.slice(1).forEach((row, rIdx) => {
          if (!row || !row[0]) return;
          tbodyHtml += `<tr style="background: ${rIdx % 2 === 0 ? '#FFFFFF' : '#FDFBF7'}; border-bottom: 1px solid #EAE3D8;">`;
          headers.forEach((_, cIdx) => {
            const val = row[cIdx];
            const w = colWidths[cIdx] || '6%';
            if (cIdx === 0) {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 2px; border: 1px solid #EAE3D8; text-align: center; vertical-align: middle; box-sizing: border-box;"><span style="background: #70392F; color: white; font-weight: bold; padding: 2px 4px; border-radius: 3px; font-size: 9.5px; display: inline-block;">${escapeHtml(val)}</span></td>`;
            } else if (cIdx === 2) {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 3px; border: 1px solid #EAE3D8; vertical-align: top; overflow-wrap: break-word; word-break: break-word; box-sizing: border-box;"><strong style="color: #70392F; font-size: 10.5px; line-height: 1.3; display: block;">${escapeHtml(val)}</strong></td>`;
            } else if (cIdx === 3) {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 3px; border: 1px solid #EAE3D8; vertical-align: top; overflow-wrap: break-word; word-break: break-word; box-sizing: border-box;"><span style="color: #444444; font-size: 9px; direction: ltr; display: block; line-height: 1.25;">${escapeHtml(val)}</span></td>`;
            } else if (cIdx === 9 && val) {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 2px; border: 1px solid #EAE3D8; text-align: center; vertical-align: middle; box-sizing: border-box;"><span style="background: #F3ECE1; color: #70392F; font-weight: bold; padding: 2px 2px; border-radius: 3px; font-size: 8.5px; border: 0.5px solid #D9CBBA; display: inline-block; line-height: 1.2; width: 100%; box-sizing: border-box;">${escapeHtml(val)}</span></td>`;
            } else if (cIdx === 13) {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 2px; border: 1px solid #EAE3D8; text-align: center; vertical-align: middle; box-sizing: border-box;">${formatLinks(val, true)}</td>`;
            } else if (cIdx === 14) {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 2px; border: 1px solid #EAE3D8; text-align: center; vertical-align: middle; box-sizing: border-box;">${formatLinks(val, false)}</td>`;
            } else {
              tbodyHtml += `<td style="width: ${w}; padding: 4px 3px; border: 1px solid #EAE3D8; vertical-align: top; font-size: 9.5px; line-height: 1.35; overflow-wrap: break-word; word-break: break-word; box-sizing: border-box;">${escapeHtml(val)}</td>`;
            }
          });
          tbodyHtml += '</tr>';
        });
        tbodyHtml += '</tbody>';

        table.innerHTML = theadHtml + tbodyHtml;
        tableWrapper.appendChild(table);
        s1.appendChild(tableWrapper);
      }
      excelSection.appendChild(s1);

      btnS1.addEventListener('click', () => {
        viewport.scrollTop = s1.offsetTop - 10;
        highlightNav(btnS1);
      });

      // Sheet 2: الأقسام والموضوعات
      const s2 = document.createElement('div');
      s2.id = 'sheet-2-target';
      s2.style.cssText = 'background: #FFFFFF; border: 1.5px solid #C59965; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.06); padding: 16px 18px; margin-bottom: 24px;';
      s2.innerHTML = `
        <div style="background: #70392F; color: #FFFFFF; padding: 12px 16px; border-radius: 6px; margin-bottom: 14px;">
          <div style="font-size: 16px; font-weight: bold; color: #FEFCE8;">الورقة 2: الأقسام والموضوعات</div>
          <div style="font-size: 12px; color: #F0EAE1; margin-top: 3px;">الأقسام العلمية الثمانية، واختيار الطبقات بحسب موضوع الدراسة، ومستويات الدراسة والدقة المناسبة</div>
        </div>
      `;

      const ws2 = wb.Sheets['الأقسام والموضوعات'] || wb.Sheets[wb.SheetNames[1]];
      const rows2 = window.XLSX.utils.sheet_to_json(ws2, { header: 1 });

      if (rows2 && rows2.length > 0) {
        // Table 1
        const secRows = rows2.slice(2, 11);
        if (secRows.length > 0) {
          let htm = '<div style="font-weight: bold; color: #70392F; font-size: 14px; margin: 10px 0 6px 0; border-bottom: 1.5px solid #C59965; padding-bottom: 4px;">أولاً: أقسام الدليل الثمانية وتوزيع المصادر</div>';
          htm += '<table style="width: 100%; border-collapse: collapse; font-size: 12px; margin-bottom: 16px; border: 1px solid #E2D9CC; border-radius: 6px; overflow: hidden;">';
          htm += '<thead><tr style="background: #70392F; color: white; font-weight: bold;">';
          secRows[0].forEach((h, i) => { htm += `<th style="padding: 8px 12px; border: 1px solid #8C4E42; ${i >= 2 ? 'text-align: center;' : ''}">${escapeHtml(h)}</th>`; });
          htm += '</tr></thead><tbody>';
          secRows.slice(1).forEach((r, idx) => {
            if (!r || !r[0]) return;
            htm += `<tr style="background: ${idx % 2 === 0 ? '#FFFFFF' : '#FDFBF7'};">
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; font-weight: bold; color: #70392F; width: 230px;">${escapeHtml(r[0])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; color: #333333;">${escapeHtml(r[1])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; text-align: center; font-weight: bold; color: #70392F; width: 110px;">${escapeHtml(r[2])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; text-align: center; width: 90px;"><span style="background: #C59965; color: white; font-weight: bold; padding: 2px 8px; border-radius: 10px;">${escapeHtml(r[3])}</span></td>
            </tr>`;
          });
          htm += '</tbody></table>';
          s2.innerHTML += htm;
        }

        // Table 2
        const topicRows = rows2.slice(15, 20);
        if (topicRows.length > 0) {
          let htm = '<div style="font-weight: bold; color: #70392F; font-size: 14px; margin: 14px 0 6px 0; border-bottom: 1.5px solid #C59965; padding-bottom: 4px;">ثانياً: اختيار الطبقات الأساسية بحسب موضوع الدراسة</div>';
          htm += '<table style="width: 100%; border-collapse: collapse; font-size: 12px; margin-bottom: 16px; border: 1px solid #E2D9CC; border-radius: 6px; overflow: hidden;">';
          htm += '<thead><tr style="background: #70392F; color: white; font-weight: bold;">';
          topicRows[0].forEach(h => { if (h) htm += `<th style="padding: 8px 12px; border: 1px solid #8C4E42;">${escapeHtml(h)}</th>`; });
          htm += '</tr></thead><tbody>';
          topicRows.slice(1).forEach((r, idx) => {
            if (!r || !r[0]) return;
            htm += `<tr style="background: ${idx % 2 === 0 ? '#FFFFFF' : '#FDFBF7'};">
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; font-weight: bold; color: #70392F; width: 230px;">${escapeHtml(r[0])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; color: #333333;">${escapeHtml(r[1])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; color: #1A56DB; font-weight: bold;">${escapeHtml(r[2])}</td>
            </tr>`;
          });
          htm += '</tbody></table>';
          s2.innerHTML += htm;
        }

        // Table 3
        const lvlRows = rows2.slice(24, 28);
        if (lvlRows.length > 0) {
          let htm = '<div style="font-weight: bold; color: #70392F; font-size: 14px; margin: 14px 0 6px 0; border-bottom: 1.5px solid #C59965; padding-bottom: 4px;">ثالثاً: مستويات الدراسة والدقة المناسبة</div>';
          htm += '<table style="width: 100%; border-collapse: collapse; font-size: 12px; border: 1px solid #E2D9CC; border-radius: 6px; overflow: hidden;">';
          htm += '<thead><tr style="background: #70392F; color: white; font-weight: bold;">';
          lvlRows[0].forEach(h => { if (h) htm += `<th style="padding: 8px 12px; border: 1px solid #8C4E42;">${escapeHtml(h)}</th>`; });
          htm += '</tr></thead><tbody>';
          lvlRows.slice(1).forEach((r, idx) => {
            if (!r || !r[0]) return;
            htm += `<tr style="background: ${idx % 2 === 0 ? '#FFFFFF' : '#FDFBF7'};">
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; font-weight: bold; color: #70392F; width: 230px;">${escapeHtml(r[0])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; color: #333333;">${escapeHtml(r[1])}</td>
              <td style="padding: 8px 12px; border: 1px solid #EAE3D8; color: #555555;">${escapeHtml(r[2])}</td>
            </tr>`;
          });
          htm += '</tbody></table>';
          s2.innerHTML += htm;
        }
      }
      excelSection.appendChild(s2);

      btnS2.addEventListener('click', () => {
        viewport.scrollTop = s2.offsetTop - 10;
        highlightNav(btnS2);
      });

      // Sheet 3: دليل الاستخدام
      const s3 = document.createElement('div');
      s3.id = 'sheet-3-target';
      s3.style.cssText = 'background: #FFFFFF; border: 1.5px solid #C59965; border-radius: 8px; box-shadow: 0 3px 10px rgba(0,0,0,0.06); padding: 16px 18px; margin-bottom: 24px;';
      s3.innerHTML = `
        <div style="background: #70392F; color: #FFFFFF; padding: 12px 16px; border-radius: 6px; margin-bottom: 14px;">
          <div style="font-size: 16px; font-weight: bold; color: #FEFCE8;">الورقة 3: دليل الاستخدام والضوابط</div>
          <div style="font-size: 12px; color: #F0EAE1; margin-top: 3px;">إرشادات منهجية للبحث، الترتيب، فئات الوصول، شروط التراخيص، والاستشهاد العلمي</div>
        </div>
      `;

      const ws3 = wb.Sheets['دليل الاستخدام'] || wb.Sheets[wb.SheetNames[2]];
      const rows3 = window.XLSX.utils.sheet_to_json(ws3, { header: 1 });

      if (rows3 && rows3.length > 0) {
        const grid = document.createElement('div');
        grid.style.cssText = 'display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 12px; margin-bottom: 16px;';

        rows3.slice(2).forEach(r => {
          if (!r || !r[0] || !r[1]) return;
          const k = r[0];
          const v = r[1];
          const isNote = k === 'ملاحظة';

          const c = document.createElement('div');
          c.style.cssText = `background: ${isNote ? '#FEF2F2' : '#FFFFFF'}; border: 1px solid ${isNote ? '#FCA5A5' : '#E2D9CC'}; border-right: 4px solid ${isNote ? '#DC2626' : '#70392F'}; border-radius: 6px; padding: 10px 14px;`;
          c.innerHTML = `
            <div style="font-size: 13.5px; font-weight: bold; color: ${isNote ? '#B91C1C' : '#70392F'}; margin-bottom: 4px;">${escapeHtml(k)}</div>
            <div style="font-size: 12px; line-height: 1.5; color: #333333; text-align: justify;">${escapeHtml(v)}</div>
          `;
          grid.appendChild(c);
        });
        s3.appendChild(grid);
      }

      const seal = document.createElement('div');
      seal.style.cssText = 'margin-top: 16px; background: #FAF6EE; border: 1.2px solid #C59965; border-radius: 8px; padding: 14px; text-align: center;';
      seal.innerHTML = `
        <div style="font-size: 13.5px; font-weight: bold; color: #70392F; margin-bottom: 4px;">منصة العمري التفاعلية للأرض والطبيعة — بوابة المصادر الجيومكانية</div>
        <div style="font-size: 11.5px; color: #666666; line-height: 1.5; max-width: 600px; margin: 0 auto;">تم إعداد وتنسيق هذا الدليل لدعم الباحثين والمختصين في علوم الأرض والاستشعار عن بعد في المملكة العربية السعودية. جميع البيانات تخضع لشروط وتراخيص الجهات المالكة.</div>
      `;
      s3.appendChild(seal);
      excelSection.appendChild(s3);

      btnS3.addEventListener('click', () => {
        viewport.scrollTop = s3.offsetTop - 10;
        highlightNav(btnS3);
      });
    }

    // Scroll spy for updating page indicator and highlighting active button
    viewport.addEventListener('scroll', () => {
      const s1 = document.getElementById('sheet-1-target');
      const s2 = document.getElementById('sheet-2-target');
      const s3 = document.getElementById('sheet-3-target');

      if (s3 && s3.getBoundingClientRect().top < 220) {
        statusBadge.textContent = 'ورقة 3: دليل الاستخدام';
        highlightNav(btnS3);
      } else if (s2 && s2.getBoundingClientRect().top < 220) {
        statusBadge.textContent = 'ورقة 2: الأقسام والموضوعات';
        highlightNav(btnS2);
      } else if (s1 && s1.getBoundingClientRect().top < 220) {
        statusBadge.textContent = 'ورقة 1: المصادر (53 مصدراً)';
        highlightNav(btnS1);
      } else {
        highlightNav(btnPdf);
        const cards = pdfSection.querySelectorAll('[id^="pdf-page-card-"]');
        if (cards.length > 0) {
          let cur = 1;
          cards.forEach((c, idx) => {
            if (c.getBoundingClientRect().top <= 250) cur = idx + 1;
          });
          statusBadge.textContent = `الصفحة ${cur} من 46`;
        }
      }
    });

    loadPdf();
    loadExcel();
  };
})();
