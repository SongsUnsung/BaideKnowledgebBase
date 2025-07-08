// 定义语言颜色映射类（添加鸿蒙语言支持）
class LanguageColors {
  javascript: string = '#f7df1e'
  typescript: string = '#3178c6'
  java: string = '#f89820'
  python: string = '#3776ab'
  html: string = '#e34f26'
  css: string = '#1572b6'
  json: string = '#000000'
  xml: string = '#005a9c'
  sql: string = '#336791'
  c: string = '#555555'
  cpp: string = '#f34b7d'
  php: string = '#777bb4'
  ruby: string = '#cc342d'
  go: string = '#00add8'
  swift: string = '#f05138'
  kotlin: string = '#7f52ff'
  rust: string = '#dea584'
  shell: string = '#89e051'
  yaml: string = '#cb171e'
  arkts: string = '#00aaff'  // 鸿蒙特有颜色
  ets: string = '#00aaff'    // 鸿蒙特有颜色
  harmony: string = '#00aaff' // 鸿蒙特有颜色

  getColor(language: string): string {
    switch (language.toLowerCase()) {
      case 'javascript': return this.javascript;
      case 'typescript': return this.typescript;
      case 'java': return this.java;
      case 'python': return this.python;
      case 'html': return this.html;
      case 'css': return this.css;
      case 'json': return this.json;
      case 'xml': return this.xml;
      case 'sql': return this.sql;
      case 'c': return this.c;
      case 'cpp': return this.cpp;
      case 'php': return this.php;
      case 'ruby': return this.ruby;
      case 'go': return this.go;
      case 'swift': return this.swift;
      case 'kotlin': return this.kotlin;
      case 'rust': return this.rust;
      case 'shell': return this.shell;
      case 'bash': return this.shell;
      case 'sh': return this.shell;
      case 'yaml': return this.yaml;
      case 'yml': return this.yaml;
    // 添加鸿蒙相关语言
      case 'arkts': return this.arkts;
      case 'ets': return this.ets;
      case 'harmony': return this.harmony;
      case 'hml': return this.html; // 鸿蒙UI语言
      default: return '#666666';
    }
  }
}

@Component
export struct LearnRichText {
  // 富文本
  @Prop richTextContent: string = ""
  private languageColors: LanguageColors = new LanguageColors()

  build() {
    Scroll() {
      RichText(this.getFormattedRichText())
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(6)
  }

  private getFormattedRichText(): string {
    let content = this.richTextContent

    // 处理代码块 ```language code ```
    content = content.replace(/```(\w+)?\n?([\s\S]*?)```/g, (match: string, lang: string, code: string): string => {
      const language = lang ? lang.toLowerCase() : 'text'
      const langColor = this.languageColors.getColor(language)
      const escapedCode = this.escapeHtml(code ? code.trim() : '')

      // 使用highlight.js进行语法高亮，灰色背景
      return `<div style="margin: 20px 0; background: #f0f0f0; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
        ${lang ? `<div style="background-color: ${langColor}; color: white; padding: 8px 16px; font-size: 13px; font-weight: 500; display: flex; align-items: center;">
          <span>${lang}</span>
          <span style="margin-left: auto; font-size: 11px; opacity: 0.7;">${language}</span>
        </div>` : ''}
        <pre style="margin: 0; padding: 16px; font-family: 'Fira Code', 'SF Mono', monospace; font-size: 14px; line-height: 1.5; color: #333; overflow-x: auto; background: #f0f0f0 !important; border: none !important;">
          <code class="hljs language-${language}">${escapedCode}</code>
        </pre>
      </div>`
    })

    // 优化行内代码
    content = content.replace(/`([^`\n]+)`/g, '<code style="background: #f1f1f1; color: #e45649; padding: 2px 6px; border-radius: 4px; font-family: monospace; font-size: 13px; border: 1px solid #e1e1e1;">$1</code>')

    // 优化标题间距
    content = content.replace(/^# (.*$)/gm, '<h1 style="color: #2c3e50; font-size: 26px; font-weight: 700; margin: 32px 0 20px; padding-bottom: 12px; border-bottom: 2px solid #3498db;">$1</h1>')
    content = content.replace(/^## (.*$)/gm, '<h2 style="color: #34495e; font-size: 22px; font-weight: 600; margin: 28px 0 18px; padding-bottom: 8px; border-bottom: 1px solid #3498db;">$1</h2>')
    content = content.replace(/^### (.*$)/gm, '<h3 style="color: #2c3e50; font-size: 19px; font-weight: 600; margin: 24px 0 16px;">$1</h3>')
    content = content.replace(/^#### (.*$)/gm, '<h4 style="color: #2c3e50; font-size: 17px; font-weight: 600; margin: 22px 0 14px;">$1</h4>')

    // 处理粗体 **text** 或 __text__
    content = content.replace(/\*\*(.*?)\*\*/g, '<strong style="font-weight: 700; color: #2c3e50; background: linear-gradient(transparent 60%, rgba(52, 152, 219, 0.2) 40%);">$1</strong>')
    content = content.replace(/__(.*?)__/g, '<strong style="font-weight: 700; color: #2c3e50; background: linear-gradient(transparent 60%, rgba(52, 152, 219, 0.2) 40%);">$1</strong>')

    // 处理斜体 *text* 或 _text_
    content = content.replace(/(?<!\*)\*([^*\n]+)\*(?!\*)/g, '<em style="font-style: italic; color: #7f8c8d; font-weight: 500;">$1</em>')
    content = content.replace(/(?<!_)_([^_\n]+)_(?!_)/g, '<em style="font-style: italic; color: #7f8c8d; font-weight: 500;">$1</em>')

    // 处理删除线 ~~text~~
    content = content.replace(/~~(.*?)~~/g, '<del style="text-decoration: line-through; color: #95a5a6; opacity: 0.8;">$1</del>')

    // 处理链接 [text](url)
    content = content.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" style="color: #3498db; text-decoration: none; font-weight: 500; border-bottom: 1px solid #3498db; transition: all 0.3s ease; padding-bottom: 1px;">$1</a>')

    // 优化图片样式 - 添加最大宽度限制
    content = content.replace(/!\[([^\]]*)\]\(([^)]+)\)/g,
      '<div style="text-align: center; margin: 24px 0;">' +
        '<img src="$2" alt="$1" style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 8px 16px rgba(0,0,0,0.1); transition: transform 0.3s ease;"/>' +
        '<div style="margin-top: 8px; font-size: 13px; color: #777; font-style: italic;">$1</div>' +
        '</div>')

    // 优化引用块
    content = content.replace(/^> (.*$)/gm, '<blockquote style="border-left: 4px solid #3498db; background: #f0f7ff; margin: 20px 0; padding: 16px 24px; color: #2c3e50; border-radius: 0 8px 8px 0; position: relative;">' +
      '<svg style="position: absolute; left: 8px; top: 8px; width: 24px; height: 24px; opacity: 0.2;" viewBox="0 0 24 24">' +
      '<path fill="currentColor" d="M6 17h3l2-4V7H5v6h3zm8 0h3l2-4V7h-6v6h3z"/>' +
      '</svg>' +
      '<div style="padding-left: 20px;">$1</div>' +
      '</blockquote>')

    // 处理段落
    content = content.replace(/\n\n+/g, '</p><p style="margin: 18px 0; line-height: 1.7; color: #444; font-size: 16px;">')
    content = content.replace(/\n/g, '<br/>')

    // 优化列表样式
    content = content.replace(/^[\-\*] (.+)$/gm, '<li style="margin: 8px 0; padding-left: 24px; position: relative; line-height: 1.6; display: flex; align-items: flex-start;">' +
      '<span style="position: absolute; left: 0; top: 8px; width: 8px; height: 8px; background: #3498db; border-radius: 50%; margin-right: 8px;"></span>$1' +
      '</li>')
    content = content.replace(/(<li[^>]*>.*<\/li>)/s, '<ul style="margin: 16px 0; padding-left: 8px;">$1</ul>')

    // 处理有序列表
    content = content.replace(/^\d+\. (.+)$/gm, '<li style="margin: 8px 0; padding-left: 24px; position: relative; line-height: 1.6; display: flex; align-items: flex-start;">' +
      '<span style="position: absolute; left: 0; top: 0; min-width: 20px; height: 20px; background: #3498db; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; margin-right: 8px;">${index + 1}</span>$1' +
      '</li>')
    content = content.replace(/(<li[^>]*>.*<\/li>)/s, '<ol style="margin: 16px 0; padding-left: 8px; counter-reset: item;">$1</ol>')

    // 处理表格
    content = this.processTable(content)

    // 处理水平分割线 ---
    content = content.replace(/^---+$/gm, '<hr style="border: none; height: 2px; background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); margin: 32px 0; border-radius: 2px; box-shadow: 0 2px 4px rgba(52, 152, 219, 0.2);"/>')

    // 处理高亮文本 ==text==
    content = content.replace(/==(.*?)==/g, '<mark style="background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%); color: #856404; padding: 2px 4px; border-radius: 3px; font-weight: 500;">$1</mark>')

    // 处理键盘按键 [[key]]
    content = content.replace(/\[\[([^\]]+)\]\]/g, '<kbd style="background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); color: #495057; padding: 4px 8px; border-radius: 4px; font-family: monospace; font-size: 12px; border: 1px solid #dee2e6; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: inline-block; margin: 0 2px;">$1</kbd>')

    // 处理脚注 [^1]
    content = content.replace(/\[\^(\d+)\]/g, '<sup id="fnref:$1" style="font-size: 0.8em;"><a href="#fn:$1" style="text-decoration: none; color: #3498db; font-weight: bold;">$1</a></sup>')

    return `
    <html>
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/styles/github-dark-dimmed.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.7.0/highlight.min.js"></script>
        <script>
          // 注册鸿蒙语言支持
          hljs.registerLanguage('arkts', function(hljs) {
            return hljs.getLanguage('typescript');
          });
          hljs.registerLanguage('ets', function(hljs) {
            return hljs.getLanguage('typescript');
          });
          hljs.registerLanguage('hml', function(hljs) {
            return hljs.getLanguage('html');
          });
          hljs.highlightAll();
        </script>
        <style>
          /* 保持原有样式 */
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
            font-size: 28px;//
            line-height: 1.7;
            color: #444;
            padding: 0 !important;
            background: #f5f7fa;
            -webkit-font-smoothing: antialiased;
          }

          .content-container {
            max-width: 100%;
            margin: 0;
            background: white;
            padding: 16px;        /* 适当的内边距 */
            border-radius: 0;     /* 移除圆角 */
            box-shadow: none;     /* 移除阴影 */


            overflow: hidden;
          }
          .content-container::after {
            content: '';
            display: block;
            height: 400px;  /* 添加400px的底部空白 */
            width: 100%;
          }

          /* 添加选中文本的样式 */
          .selected-text {
            background: #3498db !important;
            color: white !important;
          }

          .copy-button {
            position: absolute;
            top: 9px;
            right: 4px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 4px 8px;
            font-size: 12px;
            cursor: pointer;
            opacity: 0.7;
            transition: all 0.3s;
            z-index: 10;
            min-width: 40px;
            text-align: center;
            width: auto;
            white-space: nowrap;
          }
          .copy-button:hover {
            opacity: 1;
          }

          .copy-button.success {
            background: #27ae60;
          }

          .copy-button.error {
            background: #e74c3c;
          }

          /* AI分析按钮样式 */
          .ai-analyze-button {
            position: absolute;
            top: 8px;
            right: 60px;
            background: #8e44ad;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 4px 8px;
            font-size: 12px;
            cursor: pointer;
            opacity: 0.7;
            transition: opacity 0.3s;
            z-index: 10;
          }

          .ai-analyze-button:hover {
            opacity: 1;
          }

          .ai-analyze-button.loading {
            background: #f39c12;
            opacity: 1;
          }

          .ai-analyze-button.success {
            background: #27ae60;
          }

          .ai-analyze-button.error {
            background: #e74c3c;
          }

          /* API密钥输入弹窗样式 */
          .api-key-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
          }

          .api-key-modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
          }

          .api-key-modal h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 18px;
          }

          .api-key-modal p {
            color: #7f8c8d;
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.5;
          }

          .api-key-modal input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 20px;
            font-family: monospace;
          }

          .api-key-modal input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
          }

          .api-key-modal-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
          }

          .api-key-modal button {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
          }

          .api-key-modal .cancel-btn {
            background: #95a5a6;
            color: white;
          }

          .api-key-modal .cancel-btn:hover {
            background: #7f8c8d;
          }

          .api-key-modal .confirm-btn {
            background: #3498db;
            color: white;
          }

          .api-key-modal .confirm-btn:hover {
            background: #2980b9;
          }

          /* AI分析结果弹窗样式 */
          .ai-result-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
          }

          .ai-result-modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            max-width: 600px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
          }

          .ai-result-modal h3 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
          }

          .ai-result-modal .ai-icon {
            width: 24px;
            height: 24px;
            background: #8e44ad;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
            font-weight: bold;
          }

          .ai-result-content {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.6;
            color: #2c3e50;
            border-left: 4px solid #8e44ad;
          }

          .ai-result-modal button {
            padding: 10px 20px;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s;
            float: right;
          }

          .ai-result-modal button:hover {
            background: #2980b9;
          }
          /* 字体大小控制按钮样式 */
          .font-size-control {
            position: fixed;
            top: 20px;
            right: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 8px 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            z-index: 1000;
            font-size: 14px;
            color: #333;
          }

          .font-size-control button {
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 4px 8px;
            cursor: pointer;
            font-size: 12px;
            transition: background 0.3s;
          }

          .font-size-control button:hover {
            background: #2980b9;
          }

          .font-size-control .size-display {
            background: #f5f5f5;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            color: #666;
            min-width: 40px;
            text-align: center;
          }

          /* 其他样式保持不变... */
        </style>
      </head>
      <body>
      <div class="font-size-control">
  <label>字体大小：</label>
  <button onclick="decreaseFontSize()">A-</button>
  <span class="size-display" id="fontSizeDisplay">16px</span>
  <button onclick="increaseFontSize()">A+</button>
</div>
        <div class="content-container">
          ${content}
        </div>

        <script>
        // 字体大小控制功能
let currentFontSize =28 ;

// 在现有的 updateFontSize() 函数中添加以下代码
// 将原来的 updateFontSize() 函数替换为：

// 优化后的 updateFontSize() 函数
function updateFontSize() {
  document.body.style.fontSize = currentFontSize + 'px';
  document.getElementById('fontSizeDisplay').textContent = currentFontSize + 'px';

  // 改进的按钮缩放比例计算（更平滑的过渡）
  const baseSize = 20; // 基准字体大小
  const minScale = 0.6; // 最小缩放比例
  const maxScale = 1.8; // 最大缩放比例

  // 使用更平滑的缩放曲线
  let scale;
  if (currentFontSize <= baseSize) {
    // 小于基准时线性缩放
    scale = minScale + (1 - minScale) * (currentFontSize / baseSize);
  } else {
    // 大于基准时使用平方根缩放，变化更平缓
    const ratio = Math.sqrt((currentFontSize - baseSize) / baseSize);
    scale = 1 + ratio * (maxScale - 1);
  }

  scale = Math.max(minScale, Math.min(maxScale, scale));

  // 同步调整所有按钮和控件的大小
  const elements = [
    '.copy-button',
    '.ai-analyze-button',
    '.ai-model-select',
    '.font-size-control button',
    '.font-size-control .size-display'
  ];

  elements.forEach(selector => {
    document.querySelectorAll(selector).forEach(el => {
      el.style.fontSize = (12 * scale) + 'px';
      el.style.padding = (4 * scale) + 'px ' + (8 * scale) + 'px';
    });
  });

  // 特殊处理font-size-control容器
  const fontControl = document.querySelector('.font-size-control');
  if (fontControl) {
    fontControl.style.fontSize = (14 * scale) + 'px';
    fontControl.style.padding = (8 * scale) + 'px ' + (12 * scale) + 'px';
  }

  // 重新调整按钮位置
  document.querySelectorAll('.copy-button').forEach(btn => {
    btn.style.right = (4 * scale) + 'px';
    btn.style.top = (8 * scale) + 'px';
  });

  // 处理每个代码块的布局
  document.querySelectorAll('pre').forEach(pre => {
    const copyBtn = pre.querySelector('.copy-button');
    const aiContainer = pre.querySelector('div[style*="position: absolute"]');

    if (copyBtn && aiContainer) {
      const copyBtnWidth = copyBtn.offsetWidth || (40 * scale);
      const gap = 8 * scale;
      aiContainer.style.right = (copyBtnWidth + gap + 4 * scale) + 'px';
      aiContainer.style.top = (8 * scale) + 'px';
    }

    // 修复按钮遮挡问题：准确计算按钮区域高度
    let maxButtonHeight = 0;

    // 计算复制按钮的实际高度
    if (copyBtn) {
      const copyBtnRect = copyBtn.getBoundingClientRect();
      const copyBtnBottom = copyBtn.offsetTop + copyBtnRect.height;
      maxButtonHeight = Math.max(maxButtonHeight, copyBtnBottom);
    }

    // 计算AI按钮容器的实际高度
    if (aiContainer) {
      const aiRect = aiContainer.getBoundingClientRect();
      const aiBottom = aiContainer.offsetTop + aiRect.height;
      maxButtonHeight = Math.max(maxButtonHeight, aiBottom);
    }

    // 设置足够的底部边距，确保按钮不遮挡后续内容
    const preRect = pre.getBoundingClientRect();
    const preHeight = preRect.height;

    // 如果按钮超出了代码块的高度，增加相应的边距
    if (maxButtonHeight > preHeight) {
      const extraMargin = maxButtonHeight - preHeight + 10; // 额外10px间距
      pre.style.marginBottom = (20 + extraMargin) + 'px';
    } else {
      // 保持默认边距
      pre.style.marginBottom = '20px';
    }
  });

  // 延迟执行一次，确保DOM更新完成后再次调整
  setTimeout(() => {
    document.querySelectorAll('pre').forEach(pre => {
      const copyBtn = pre.querySelector('.copy-button');
      const aiContainer = pre.querySelector('div[style*="position: absolute"]');

      if (copyBtn || aiContainer) {
        let maxButtonBottom = 0;

        if (copyBtn) {
          const rect = copyBtn.getBoundingClientRect();
          const preRect = pre.getBoundingClientRect();
          const relativeBottom = (rect.bottom - preRect.top);
          maxButtonBottom = Math.max(maxButtonBottom, relativeBottom);
        }

        if (aiContainer) {
          const rect = aiContainer.getBoundingClientRect();
          const preRect = pre.getBoundingClientRect();
          const relativeBottom = (rect.bottom - preRect.top);
          maxButtonBottom = Math.max(maxButtonBottom, relativeBottom);
        }

        // 如果按钮超出代码块，调整边距
        const preHeight = pre.getBoundingClientRect().height;
        if (maxButtonBottom > preHeight) {
          const extraMargin = maxButtonBottom - preHeight + 10;
          pre.style.marginBottom = (20 + extraMargin) + 'px';
        }
      }
    });
  }, 100);
}

function increaseFontSize() {
  if (currentFontSize < 80) {
    currentFontSize += 2;
    updateFontSize();
  }
}

function decreaseFontSize() {
  if (currentFontSize > 12) {
    currentFontSize -= 2;
    updateFontSize();
  }
}
          // 创建AI分析按钮
          document.querySelectorAll('pre').forEach(pre => {
            // 确保只添加一次按钮
            if (pre.querySelector('.ai-analyze-button')) return;

            // 创建容器
            const buttonContainer = document.createElement('div');
            buttonContainer.style.position = 'absolute';
            buttonContainer.style.top = '8px';
            buttonContainer.style.right = '65px';
            buttonContainer.style.display = 'flex';
            buttonContainer.style.alignItems = 'center';
            buttonContainer.style.gap = '5px';
            buttonContainer.style.zIndex = '10';

            // 创建AI模型选择下拉列表
            const modelSelect = document.createElement('select');
            modelSelect.className = 'ai-model-select';
            modelSelect.style.background = '#34495e';
            modelSelect.style.color = 'white';
            modelSelect.style.border = 'none';
            modelSelect.style.borderRadius = '4px';
            modelSelect.style.padding = '4px 8px';
            modelSelect.style.fontSize = '12px';
            modelSelect.style.cursor = 'pointer';
            modelSelect.style.opacity = '0.8';
            modelSelect.style.transition = 'opacity 0.3s';



            // 添加选项
            const models = [
              { value: 'gpt-3.5-turbo', label: 'GPT-3.5' },
              { value: 'gpt-4o-mini', label: 'GPT-4o-mini' },
              { value: 'gpt-4o', label: 'GPT-4o' },
              { value: 'deepseek-chat', label: 'DeepSeek' }
            ];

            models.forEach(model => {
              const option = document.createElement('option');
              option.value = model.value;
              option.textContent = model.label;
              modelSelect.appendChild(option);
            });

            // 鼠标悬停效果
            modelSelect.addEventListener('mouseenter', () => {
              modelSelect.style.opacity = '1';
            });

            modelSelect.addEventListener('mouseleave', () => {
              modelSelect.style.opacity = '0.8';
            });

            // 创建AI分析按钮
            const aiButton = document.createElement('button');
            aiButton.innerHTML = 'AI分析';
            aiButton.className = 'ai-analyze-button';
            aiButton.style.position = 'static'; // 改为相对定位
            aiButton.style.top = 'auto';
            aiButton.style.right = 'auto';

            // 添加点击事件
            aiButton.addEventListener('click', (e) => {
              e.preventDefault();
              e.stopPropagation();

              const code = pre.querySelector('code');
              if (code) {
                const text = code.innerText || code.textContent;
                const selectedModel = modelSelect.value;

                // 关键：从代码块类名获取语言类型
                const classList = code.className.split(/\s+/);
                let language = 'text';
                for (let cls of classList) {
                  if (cls.startsWith('language-')) {
                    language = cls.replace('language-', '');
                    break;
                  }
                }

                analyzeCode(text, language, aiButton, selectedModel);
              }
            });

            // 将选择器和按钮添加到容器
            buttonContainer.appendChild(modelSelect);
            buttonContainer.appendChild(aiButton);

            pre.style.position = 'relative';
            pre.appendChild(buttonContainer);
            pre.querySelector('code').style.paddingTop = '60px';
          });

          // API密钥存储（内存中）
          let apiKey = null;


          // 显示API密钥输入弹窗
          function showApiKeyModal(callback) {
            const modal = document.createElement('div');
            modal.className = 'api-key-modal';
            modal.innerHTML = \`
              <div class="api-key-modal-content">
                <h3>🤖 AI代码分析</h3>
                <p>首次使用需要输入ChatGPT API密钥。密钥仅存储在内存中，关闭页面后会清除。</p>
                <input type="text" id="apiKeyInput" placeholder="请输入您的ChatGPT API密钥 (sk-...)" />
                <div class="api-key-modal-buttons">
                  <button class="cancel-btn" onclick="closeApiKeyModal()">取消</button>
                  <button class="confirm-btn" onclick="saveApiKey()">确认</button>
                </div>
              </div>
            \`;

            document.body.appendChild(modal);

            // 聚焦输入框
            setTimeout(() => {
              document.getElementById('apiKeyInput').focus();
            }, 100);

            // 回车键确认
            document.getElementById('apiKeyInput').addEventListener('keypress', (e) => {
              if (e.key === 'Enter') {
                saveApiKey();
              }
            });

            // 存储回调函数
            window.apiKeyCallback = callback;
          }

          // 关闭API密钥弹窗
          function closeApiKeyModal() {
            const modal = document.querySelector('.api-key-modal');
            if (modal) {
              modal.remove();
            }
          }

          // 保存API密钥
          function saveApiKey() {
            const input = document.getElementById('apiKeyInput');
            const key = input.value.trim();

            if (!key) {
              alert('请输入API密钥');
              return;
            }

            if (!key.startsWith('sk-')) {
              alert('API密钥格式不正确，应该以 sk- 开头');
              return;
            }

            apiKey = key;
            closeApiKeyModal();

            // 执行回调函数
            if (window.apiKeyCallback) {
              window.apiKeyCallback();
              window.apiKeyCallback = null;
            }
          }

          // 显示AI分析结果弹窗
          function showAiResultModal(result) {
            const modal = document.createElement('div');
            modal.className = 'ai-result-modal';
            modal.innerHTML = \`
              <div class="ai-result-modal-content">
                <h3>
                  <span class="ai-icon">AI</span>
                  代码分析结果
                </h3>
                <div class="ai-result-content">
                  \${result.replace(/\\n/g, '<br>')}
                </div>
                <button onclick="closeAiResultModal()">关闭</button>
              </div>
            \`;

            document.body.appendChild(modal);

            // 点击背景关闭
            modal.addEventListener('click', (e) => {
              if (e.target === modal) {
                closeAiResultModal();
              }
            });
          }

          // 关闭AI分析结果弹窗
          function closeAiResultModal() {
            const modal = document.querySelector('.ai-result-modal');
            if (modal) {
              modal.remove();
            }
          }

          // AI分析代码 - 修复后的逻辑
          async function analyzeCode(code, language, button, model = 'gpt-3.5-turbo') {
            if (!apiKey) {
              showApiKeyModal(() => {
                analyzeCode(code, language, button, model);
              });
              return;
            }

            button.innerHTML = '分析中...';
            button.classList.add('loading');

            try {
              const prompt = \`请分析以下\${language}代码进行全面分析，要求详尽、专业，内容包括但不限于以下几个方面：
1. 【功能概述】：说明代码的整体功能和用途。
2. 【核心逻辑解析】：逐步解析代码的主要流程、关键函数和核心算法。
3. 【设计亮点】：指出代码中值得学习或借鉴的设计思路、结构优化或语法技巧。
4. 【潜在问题】：分析可能存在的逻辑缺陷、边界问题、性能瓶颈或安全隐患。
5. 【改进建议与示例】：提出可行的优化建议，并附上具体代码示例。
请用条理清晰、分段明确的方式输出分析结果。
直接返回HTML代码，不要用markdown格式
使用以下HTML标签和样式：
   - 标题用 <h3 style="color: #2c3e50; margin: 20px 0 12px; font-size: 18px; font-weight: 600;">
   - 段落用 <p style="margin: 12px 0; line-height: 1.6; color: #444;">
   - 代码块用 <pre style="background: #f6f8fa; padding: 16px; border-radius: 6px; margin: 16px 0; overflow-x: auto; border: 1px solid #e1e4e8;"><code style="font-family: 'SFMono-Regular', Consolas, monospace; font-size: 14px; color: #24292e;">[代码内容]</code></pre>
   - 行内代码用 <code style="background: #f6f8fa; color: #d73a49; padding: 2px 4px; border-radius: 3px; font-family: monospace; font-size: 0.9em;">
   - 列表用 <ul style="margin: 12px 0; padding-left: 20px;"><li style="margin: 6px 0; line-height: 1.5;">
   - 重点文字用 <strong style="font-weight: 600; color: #2c3e50;">
   - 提示框用 <div style="background: #e8f4f8; border-left: 4px solid #3498db; padding: 12px 16px; margin: 16px 0; border-radius: 4px;">
确保HTML格式正确，所有标签都要闭合
代码：
\${code}\`;

              const response = await fetch('https://api.chatanywhere.tech/v1/chat/completions', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': \`Bearer \${apiKey}\`
                },
                body: JSON.stringify({
                  model: model, // 使用选择的模型
                  messages: [
                    {
                      role: 'user',
                      content: prompt
                    }
                  ],
                  max_tokens: 1000,
                  temperature: 0.7
                })
              });

              if (!response.ok) {
                throw new Error(\`API请求失败: \${response.status}\`);
              }

              const data = await response.json();
              const result = data.choices[0].message.content;

              showAiResultModal(result);

              button.innerHTML = '分析完成';
              button.classList.remove('loading');
              button.classList.add('success');

              setTimeout(() => {
                button.innerHTML = 'AI分析';
                button.classList.remove('success');
              }, 2000);

            } catch (error) {
              console.error('AI分析失败:', error);

              let errorMessage = '分析失败';
              if (error.message.includes('401')) {
                errorMessage = 'API密钥无效';
                apiKey = null; // 清除无效密钥
              } else if (error.message.includes('429')) {
                errorMessage = '请求过于频繁';
              } else if (error.message.includes('insufficient_quota')) {
                errorMessage = 'API配额不足';
              }

              button.innerHTML = errorMessage;
              button.classList.remove('loading');
              button.classList.add('error');

              setTimeout(() => {
                button.innerHTML = 'AI分析';
                button.classList.remove('error');
              }, 3000);
            }
          }
          // 改进的复制功能 - 多种方案兼容
          function copyToClipboard(text, button) {
            // 方案1: 尝试现代 Clipboard API
            if (navigator.clipboard && navigator.clipboard.writeText) {
              navigator.clipboard.writeText(text).then(() => {
                showCopySuccess(button);
              }).catch(() => {
                // 如果失败，尝试传统方法
                fallbackCopyTextToClipboard(text, button);
              });
            } else {
              // 方案2: 传统的文本选择复制方法
              fallbackCopyTextToClipboard(text, button);
            }
          }

          function fallbackCopyTextToClipboard(text, button) {
            // 创建临时的textarea元素
            const textArea = document.createElement('textarea');
            textArea.value = text;
            textArea.style.position = 'fixed';
            textArea.style.left = '-999999px';
            textArea.style.top = '-999999px';
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();

            try {
              // 尝试执行复制命令
              const successful = document.execCommand('copy');
              if (successful) {
                showCopySuccess(button);
              } else {
                showCopyError(button);
              }
            } catch (err) {
              console.error('复制失败:', err);
              showCopyError(button);
            }

            document.body.removeChild(textArea);
          }

          function showCopySuccess(button) {
            button.innerHTML = '已复制!';
            button.classList.add('success');
            setTimeout(() => {
              button.innerHTML = '复制';
              button.classList.remove('success');
            }, 2000);
          }

          function showCopyError(button) {
            button.innerHTML = '长按选择';
            button.classList.add('error');
            setTimeout(() => {
              button.innerHTML = '复制';
              button.classList.remove('error');
            }, 3000);
          }

          // 初始化复制按钮
          document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('pre').forEach(pre => {
              const button = document.createElement('button');
              button.innerHTML = '复制';
              button.className = 'copy-button';

              button.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();

                const code = pre.querySelector('code');
                if (code) {
                  const text = code.innerText || code.textContent;
                  copyToClipboard(text, button);
                }
              });

              // 添加长按选择功能（移动端友好）
              let longPressTimer;
              button.addEventListener('touchstart', (e) => {
                longPressTimer = setTimeout(() => {
                  const code = pre.querySelector('code');
                  if (code) {
                    // 选中代码文本
                    const selection = window.getSelection();
                    const range = document.createRange();
                    range.selectNodeContents(code);
                    selection.removeAllRanges();
                    selection.addRange(range);

                    button.innerHTML = '已选中';
                    button.classList.add('success');
                    setTimeout(() => {
                      button.innerHTML = '复制';
                      button.classList.remove('success');
                    }, 2000);
                  }
                }, 1000);
              });

              button.addEventListener('touchend', () => {
                clearTimeout(longPressTimer);
              });

              pre.style.position = 'relative';
              pre.appendChild(button);
            });

            // 确保代码块样式一致
            document.querySelectorAll('pre, pre code').forEach(el => {
              el.style.backgroundColor = '#f0f0f0';
              el.style.border = 'none';
            });

            // 图片加载优化
            document.querySelectorAll('img').forEach(img => {
              // 确保图片不超出容器
              img.style.maxWidth = '100%';
              img.style.width = 'auto';
              img.style.height = 'auto';
              img.style.display = 'block';
              img.style.margin = '0 auto';
              img.style.boxSizing = 'border-box';

              // 图片加载失败处理
              img.onerror = function() {
                this.style.display = 'none';
                const parent = this.parentElement;
                if (parent) {
                  parent.innerHTML = '<div style="padding: 20px; text-align: center; color: #999; border: 2px dashed #ddd; border-radius: 8px;">图片加载失败</div>';
                }
              };

              // 图片加载成功后确保尺寸正确
              img.onload = function() {
                this.style.maxWidth = '100%';
                this.style.width = 'auto';
                this.style.height = 'auto';
              };
            });
          });
        </script>
      </body>
    </html>
  `
  }

  // 处理表格
  private processTable(content: string): string {
    const tableRegex = /(\|[^\n]+\|\n)+/g
    return content.replace(tableRegex, (match: string): string => {
      const rows = match.trim().split('\n')
      if (rows.length < 2) return match

      let tableHtml = '<table style="width: 100%; margin: 24px 0; border-collapse: collapse;">'

      rows.forEach((row: string, index: number) => {
        if (index === 1 && row.includes('---')) return // 跳过分隔行

        const cells = row.split('|').filter((cell: string) => cell.trim() !== '')
        const tag = index === 0 ? 'th' : 'td'

        tableHtml += '<tr>'
        cells.forEach((cell: string) => {
          tableHtml += `<${tag} style="padding: 12px 16px; border: 1px solid #eee; text-align: left;">${cell.trim()}</${tag}>`
        })
        tableHtml += '</tr>'
      })

      tableHtml += '</table>'
      return tableHtml
    })
  }


  // HTML转义
  private escapeHtml(text: string): string {
    return text
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')
  }
}