# tools/document-generation

Document quality utilities for the ai_software_factory pipeline.

## Scripts

| Script | Purpose | Formats |
|--------|---------|---------|
| `spellcheck_document.py` | Spell-check documents | PPTX, DOCX, TXT, MD, PDF |
| `validate_office_file.py` | Validate Office file structure | PPTX, DOCX, XLSX |

## spellcheck_document.py

```bash
# Check a PPTX presentation
python tools/document-generation/spellcheck_document.py slides.pptx --lang pt-BR

# Check DOCX with LanguageTool (needs LT running locally on :8081)
python tools/document-generation/spellcheck_document.py report.docx --backend languagetool --lang pt-BR

# Check all Markdown files
python tools/document-generation/spellcheck_document.py "**/*.md" --lang en-US

# Save results to JSON
python tools/document-generation/spellcheck_document.py doc.pptx --output spell_results.json
```

### Backends

| Backend | Install | Best For |
|---------|---------|---------|
| `pyspellchecker` (default) | `pip install pyspellchecker` | Fast, offline, basic |
| `languagetool` | `pip install language-tool-python` | Grammar + spelling, local or API |
| `phunspell` | `pip install phunspell` | Hunspell-quality, offline |

## validate_office_file.py

```bash
# Validate a PPTX
python tools/document-generation/validate_office_file.py presentation.pptx

# Strict mode (warnings become errors)
python tools/document-generation/validate_office_file.py report.docx --strict

# Validate all XLSX files, save report
python tools/document-generation/validate_office_file.py "*.xlsx" --output validation.json
```

### Checks Performed

**PPTX:**
- Empty slides
- Text overflow in shapes
- Missing alt text on images
- ZIP integrity

**DOCX:**
- Missing document title
- No headings in long documents
- Broken external image links
- Very long paragraphs

**XLSX:**
- Empty sheets
- Overly wide sheets (>100 columns)
- ZIP integrity

## Dependencies

```bash
pip install python-pptx python-docx openpyxl pyspellchecker pypdf
```

For LanguageTool backend, run locally:
```bash
docker run -p 8081:8010 silviof/docker-languagetool
```
