---
name: n8n-mcp-tools-expert
description: Expert guide for using n8n-mcp MCP tools effectively. Use when searching for nodes, validating configurations, accessing templates, managing workflows, or using any n8n-mcp tool. Provides tool selection guidance, parameter formats, and common patterns.
---

# n8n MCP Tools Expert

Master guide for using n8n-mcp MCP server tools to build workflows.

---

## Tool Categories

n8n-mcp provides tools organized into categories:

1. **Node Discovery** → [SEARCH_GUIDE.md](resources/SEARCH_GUIDE.md)
2. **Configuration Validation** → [VALIDATION_GUIDE.md](resources/VALIDATION_GUIDE.md)
3. **Workflow Management** → [WORKFLOW_GUIDE.md](resources/WORKFLOW_GUIDE.md)
4. **Template Library** - Search and deploy 2,700+ real workflows
5. **Documentation & Guides** - Tool docs, AI agent guide, Code node guides

---

## Quick Reference

### Most Used Tools (by success rate)

| Tool | Use When | Speed |
|------|----------|-------|
| `mcp_n8n-mcp_search_nodes` | Finding nodes by keyword | <20ms |
| `mcp_n8n-mcp_get_node` | Understanding node operations (detail="standard") | <10ms |
| `mcp_n8n-mcp_validate_node` | Checking configurations (mode="full") | <100ms |
| `mcp_n8n-mcp_n8n_create_workflow` | Creating workflows | 100-500ms |
| `mcp_n8n-mcp_n8n_update_partial_workflow` | Editing workflows (MOST USED!) | 50-200ms |
| `mcp_n8n-mcp_n8n_validate_workflow` | Checking complete workflow | 100-500ms |
| `mcp_n8n-mcp_n8n_deploy_template` | Deploy template to n8n instance | 200-500ms |

---

## Tool Selection Guide

### Finding the Right Node

**Workflow**:
```
1. mcp_n8n-mcp_search_nodes({query: "keyword"})
2. mcp_n8n-mcp_get_node({nodeType: "nodes-base.name"})
3. [Optional] mcp_n8n-mcp_get_node({nodeType: "nodes-base.name", mode: "docs"})
```

**Example**:
```javascript
// Step 1: Search
mcp_n8n-mcp_search_nodes({query: "slack"})
// Returns: nodes-base.slack

// Step 2: Get details
mcp_n8n-mcp_get_node({nodeType: "nodes-base.slack"})
// Returns: operations, properties, examples (standard detail)

// Step 3: Get readable documentation
mcp_n8n-mcp_get_node({nodeType: "nodes-base.slack", mode: "docs"})
// Returns: markdown documentation
```

**Common pattern**: search → mcp_n8n-mcp_get_node (18s average)

### Validating Configuration

**Workflow**:
```
1. mcp_n8n-mcp_validate_node({nodeType, config: {}, mode: "minimal"}) - Check required fields
2. mcp_n8n-mcp_validate_node({nodeType, config, profile: "runtime"}) - Full validation
3. [Repeat] Fix errors, validate again
```

**Common pattern**: validate → fix → validate (23s thinking, 58s fixing per cycle)

### Managing Workflows

**Workflow**:
```
1. mcp_n8n-mcp_n8n_create_workflow({name, nodes, connections})
2. mcp_n8n-mcp_n8n_validate_workflow({id})
3. mcp_n8n-mcp_n8n_update_partial_workflow({id, operations: [...]})
4. mcp_n8n-mcp_n8n_validate_workflow({id}) again
5. mcp_n8n-mcp_n8n_update_partial_workflow({id, operations: [{type: "activateWorkflow"}]})
```

**Common pattern**: iterative updates (56s average between edits)

---

## Critical: nodeType Formats

**Two different formats** for different tools!

### Format 1: Search/Validate Tools
```javascript
// Use SHORT prefix
"nodes-base.slack"
"nodes-base.httpRequest"
"nodes-base.webhook"
"nodes-langchain.agent"
```

**Tools that use this**:
- mcp_n8n-mcp_search_nodes (returns this format)
- mcp_n8n-mcp_get_node
- mcp_n8n-mcp_validate_node
- mcp_n8n-mcp_n8n_validate_workflow

### Format 2: Workflow Tools
```javascript
// Use FULL prefix
"n8n-nodes-base.slack"
"n8n-nodes-base.httpRequest"
"n8n-nodes-base.webhook"
"@n8n/n8n-nodes-langchain.agent"
```

**Tools that use this**:
- mcp_n8n-mcp_n8n_create_workflow
- mcp_n8n-mcp_n8n_update_partial_workflow

### Conversion

```javascript
// mcp_n8n-mcp_search_nodes returns BOTH formats
{
  "nodeType": "nodes-base.slack",          // For search/validate tools
  "workflowNodeType": "n8n-nodes-base.slack"  // For workflow tools
}
```

---

## Common Mistakes

### Mistake 1: Wrong nodeType Format

**Problem**: "Node not found" error

```javascript
// WRONG
mcp_n8n-mcp_get_node({nodeType: "slack"})  // Missing prefix
mcp_n8n-mcp_get_node({nodeType: "n8n-nodes-base.slack"})  // Wrong prefix

// CORRECT
mcp_n8n-mcp_get_node({nodeType: "nodes-base.slack"})
```

### Mistake 2: Using detail="full" by Default

**Problem**: Huge payload, slower response, token waste

```javascript
// WRONG - Returns 3-8K tokens, use sparingly
mcp_n8n-mcp_get_node({nodeType: "nodes-base.slack", detail: "full"})

// CORRECT - Returns 1-2K tokens, covers 95% of use cases
mcp_n8n-mcp_get_node({nodeType: "nodes-base.slack"})  // detail="standard" is default
mcp_n8n-mcp_get_node({nodeType: "nodes-base.slack", detail: "standard"})
```

**When to use detail="full"**:
- Debugging complex configuration issues
- Need complete property schema with all nested options
- Exploring advanced features

**Better alternatives**:
1. `mcp_n8n-mcp_get_node({detail: "standard"})` - for operations list (default)
2. `mcp_n8n-mcp_get_node({mode: "docs"})` - for readable documentation
3. `mcp_n8n-mcp_get_node({mode: "search_properties", propertyQuery: "auth"})` - for specific property

### Mistake 3: Not Using Validation Profiles

**Problem**: Too many false positives OR missing real errors

**Profiles**:
- `minimal` - Only required fields (fast, permissive)
- `runtime` - Values + types (recommended for pre-deployment)
- `ai-friendly` - Reduce false positives (for AI configuration)
- `strict` - Maximum validation (for production)

```javascript
// WRONG - Uses default profile
mcp_n8n-mcp_validate_node({nodeType, config})

// CORRECT - Explicit profile
mcp_n8n-mcp_validate_node({nodeType, config, profile: "runtime"})
```

### Mistake 4: Ignoring Auto-Sanitization

**What happens**: ALL nodes sanitized on ANY workflow update

**Auto-fixes**:
- Binary operators (equals, contains) → removes singleValue
- Unary operators (isEmpty, isNotEmpty) → adds singleValue: true
- IF/Switch nodes → adds missing metadata

**Cannot fix**:
- Broken connections
- Branch count mismatches
- Paradoxical corrupt states

```javascript
// After ANY update, auto-sanitization runs on ALL nodes
mcp_n8n-mcp_n8n_update_partial_workflow({id, operations: [...]})
// → Automatically fixes operator structures
```

### Mistake 5: Not Using Smart Parameters

**Problem**: Complex sourceIndex calculations for multi-output nodes

**Old way** (manual):
```javascript
// IF node connection
{
  type: "addConnection",
  source: "IF",
  target: "Handler",
  sourceIndex: 0  // Which output? Hard to remember!
}
```

**New way** (smart parameters):
```javascript
// IF node - semantic branch names
{
  type: "addConnection",
  source: "IF",
  target: "True Handler",
  branch: "true"  // Clear and readable!
}

{
  type: "addConnection",
  source: "IF",
  target: "False Handler",
  branch: "false"
}

// Switch node - semantic case numbers
{
  type: "addConnection",
  source: "Switch",
  target: "Handler A",
  case: 0
}
```

### Mistake 6: Not Using intent Parameter

**Problem**: Less helpful tool responses

```javascript
// WRONG - No context for response
mcp_n8n-mcp_n8n_update_partial_workflow({
  id: "abc",
  operations: [{type: "addNode", node: {...}}]
})

// CORRECT - Better AI responses
mcp_n8n-mcp_n8n_update_partial_workflow({
  id: "abc",
  intent: "Add error handling for API failures",
  operations: [{type: "addNode", node: {...}}]
})
```

---

## Tool Usage Patterns

### Pattern 1: Node Discovery (Most Common)

**Common workflow**: 18s average between steps

```javascript
// Step 1: Search (fast!)
const results = await mcp_n8n-mcp_search_nodes({
  query: "slack",
  mode: "OR",  // Default: any word matches
  limit: 20
});
// → Returns: nodes-base.slack, nodes-base.slackTrigger

// Step 2: Get details (~18s later, user reviewing results)
const details = await mcp_n8n-mcp_get_node({
  nodeType: "nodes-base.slack",
  includeExamples: true  // Get real template configs
});
// → Returns: operations, properties, metadata
```

### Pattern 2: Validation Loop

**Typical cycle**: 23s thinking, 58s fixing

```javascript
// Step 1: Validate
const result = await mcp_n8n-mcp_validate_node({
  nodeType: "nodes-base.slack",
  config: {
    resource: "channel",
    operation: "create"
  },
  profile: "runtime"
});

// Step 2: Check errors (~23s thinking)
if (!result.valid) {
  console.log(result.errors);  // "Missing required field: name"
}

// Step 3: Fix config (~58s fixing)
config.name = "general";

// Step 4: Validate again
await mcp_n8n-mcp_validate_node({...});  // Repeat until clean
```

### Pattern 3: Workflow Editing

**Most used update tool**: 99.0% success rate, 56s average between edits

```javascript
// Iterative workflow building (NOT one-shot!)
// Edit 1
await mcp_n8n-mcp_n8n_update_partial_workflow({
  id: "workflow-id",
  intent: "Add webhook trigger",
  operations: [{type: "addNode", node: {...}}]
});

// ~56s later...

// Edit 2
await mcp_n8n-mcp_n8n_update_partial_workflow({
  id: "workflow-id",
  intent: "Connect webhook to processor",
  operations: [{type: "addConnection", source: "...", target: "..."}]
});

// ~56s later...

// Edit 3 (validation)
await mcp_n8n-mcp_n8n_validate_workflow({id: "workflow-id"});

// Ready? Activate!
await mcp_n8n-mcp_n8n_update_partial_workflow({
  id: "workflow-id",
  intent: "Activate workflow for production",
  operations: [{type: "activateWorkflow"}]
});
```

---

## Detailed Guides

### Node Discovery Tools
See [SEARCH_GUIDE.md](resources/SEARCH_GUIDE.md) for:
- mcp_n8n-mcp_search_nodes
- mcp_n8n-mcp_get_node with detail levels (minimal, standard, full)
- mcp_n8n-mcp_get_node modes (info, docs, search_properties, versions)

### Validation Tools
See [VALIDATION_GUIDE.md](resources/VALIDATION_GUIDE.md) for:
- Validation profiles explained
- mcp_n8n-mcp_validate_node with modes (minimal, full)
- mcp_n8n-mcp_n8n_validate_workflow complete structure
- Auto-sanitization system
- Handling validation errors

### Workflow Management
See [WORKFLOW_GUIDE.md](resources/WORKFLOW_GUIDE.md) for:
- mcp_n8n-mcp_n8n_create_workflow
- mcp_n8n-mcp_n8n_update_partial_workflow (17 operation types!)
- Smart parameters (branch, case)
- AI connection types (8 types)
- Workflow activation (activateWorkflow/deactivateWorkflow)
- mcp_n8n-mcp_n8n_deploy_template
- mcp_n8n-mcp_n8n_workflow_versions

---

## Template Usage

### Search Templates

```javascript
// Search by keyword (default mode)
mcp_n8n-mcp_search_templates({
  query: "webhook slack",
  limit: 20
});

// Search by node types
mcp_n8n-mcp_search_templates({
  searchMode: "by_nodes",
  nodeTypes: ["n8n-nodes-base.httpRequest", "n8n-nodes-base.slack"]
});

// Search by task type
mcp_n8n-mcp_search_templates({
  searchMode: "by_task",
  task: "webhook_processing"
});

// Search by metadata (complexity, setup time)
mcp_n8n-mcp_search_templates({
  searchMode: "by_metadata",
  complexity: "simple",
  maxSetupMinutes: 15
});
```

### Get Template Details

```javascript
mcp_n8n-mcp_get_template({
  templateId: 2947,
  mode: "structure"  // nodes+connections only
});

mcp_n8n-mcp_get_template({
  templateId: 2947,
  mode: "full"  // complete workflow JSON
});
```

### Deploy Template Directly

```javascript
// Deploy template to your n8n instance
mcp_n8n-mcp_n8n_deploy_template({
  templateId: 2947,
  name: "My Weather to Slack",  // Custom name (optional)
  autoFix: true,  // Auto-fix common issues (default)
  autoUpgradeVersions: true  // Upgrade node versions (default)
});
// Returns: workflow ID, required credentials, fixes applied
```

---

## Self-Help Tools

### Get Tool Documentation

```javascript
// Overview of all tools
mcp_n8n-mcp_tools_documentation()

// Specific tool details
mcp_n8n-mcp_tools_documentation({
  topic: "mcp_n8n-mcp_search_nodes",
  depth: "full"
})

// Code node guides
mcp_n8n-mcp_tools_documentation({topic: "javascript_code_node_guide", depth: "full"})
mcp_n8n-mcp_tools_documentation({topic: "python_code_node_guide", depth: "full"})
```

### AI Agent Guide

```javascript
// Comprehensive AI workflow guide
ai_agents_guide()
// Returns: Architecture, connections, tools, validation, best practices
```

### Health Check

```javascript
// Quick health check
mcp_n8n-mcp_n8n_health_check()

// Detailed diagnostics
mcp_n8n-mcp_n8n_health_check({mode: "diagnostic"})
// → Returns: status, env vars, tool status, API connectivity
```

---

## Tool Availability

**Always Available** (no n8n API needed):
- mcp_n8n-mcp_search_nodes, mcp_n8n-mcp_get_node
- mcp_n8n-mcp_validate_node, mcp_n8n-mcp_n8n_validate_workflow
- mcp_n8n-mcp_search_templates, mcp_n8n-mcp_get_template
- mcp_n8n-mcp_tools_documentation, ai_agents_guide

**Requires n8n API** (N8N_API_URL + N8N_API_KEY):
- mcp_n8n-mcp_n8n_create_workflow
- mcp_n8n-mcp_n8n_update_partial_workflow
- mcp_n8n-mcp_n8n_validate_workflow (by ID)
- mcp_n8n-mcp_n8n_list_workflows, mcp_n8n-mcp_n8n_get_workflow
- mcp_n8n-mcp_n8n_test_workflow
- mcp_n8n-mcp_n8n_executions
- mcp_n8n-mcp_n8n_deploy_template
- mcp_n8n-mcp_n8n_workflow_versions
- mcp_n8n-mcp_n8n_autofix_workflow

If API tools unavailable, use templates and validation-only workflows.

---

## Unified Tool Reference

### mcp_n8n-mcp_get_node (Unified Node Information)

**Detail Levels** (mode="info", default):
- `minimal` (~200 tokens) - Basic metadata only
- `standard` (~1-2K tokens) - Essential properties + operations (RECOMMENDED)
- `full` (~3-8K tokens) - Complete schema (use sparingly)

**Operation Modes**:
- `info` (default) - Node schema with detail level
- `docs` - Readable markdown documentation
- `search_properties` - Find specific properties (use with propertyQuery)
- `versions` - List all versions with breaking changes
- `compare` - Compare two versions
- `breaking` - Show only breaking changes
- `migrations` - Show auto-migratable changes

```javascript
// Standard (recommended)
mcp_n8n-mcp_get_node({nodeType: "nodes-base.httpRequest"})

// Get documentation
mcp_n8n-mcp_get_node({nodeType: "nodes-base.webhook", mode: "docs"})

// Search for properties
mcp_n8n-mcp_get_node({nodeType: "nodes-base.httpRequest", mode: "search_properties", propertyQuery: "auth"})

// Check versions
mcp_n8n-mcp_get_node({nodeType: "nodes-base.executeWorkflow", mode: "versions"})
```

### mcp_n8n-mcp_validate_node (Unified Validation)

**Modes**:
- `full` (default) - Comprehensive validation with errors/warnings/suggestions
- `minimal` - Quick required fields check only

**Profiles** (for mode="full"):
- `minimal` - Very lenient
- `runtime` - Standard (default, recommended)
- `ai-friendly` - Balanced for AI workflows
- `strict` - Most thorough (production)

```javascript
// Full validation with runtime profile
mcp_n8n-mcp_validate_node({nodeType: "nodes-base.slack", config: {...}, profile: "runtime"})

// Quick required fields check
mcp_n8n-mcp_validate_node({nodeType: "nodes-base.webhook", config: {}, mode: "minimal"})
```

---

## Performance Characteristics

| Tool | Response Time | Payload Size |
|------|---------------|--------------|
| mcp_n8n-mcp_search_nodes | <20ms | Small |
| mcp_n8n-mcp_get_node (standard) | <10ms | ~1-2KB |
| mcp_n8n-mcp_get_node (full) | <100ms | 3-8KB |
| mcp_n8n-mcp_validate_node (minimal) | <50ms | Small |
| mcp_n8n-mcp_validate_node (full) | <100ms | Medium |
| mcp_n8n-mcp_n8n_validate_workflow | 100-500ms | Medium |
| mcp_n8n-mcp_n8n_create_workflow | 100-500ms | Medium |
| mcp_n8n-mcp_n8n_update_partial_workflow | 50-200ms | Small |
| mcp_n8n-mcp_n8n_deploy_template | 200-500ms | Medium |

---

## Best Practices

### Do
- Use `mcp_n8n-mcp_get_node({detail: "standard"})` for most use cases
- Specify validation profile explicitly (`profile: "runtime"`)
- Use smart parameters (`branch`, `case`) for clarity
- Include `intent` parameter in workflow updates
- Follow search → mcp_n8n-mcp_get_node → validate workflow
- Iterate workflows (avg 56s between edits)
- Validate after every significant change
- Use `includeExamples: true` for real configs
- Use `mcp_n8n-mcp_n8n_deploy_template` for quick starts

### Don't
- Use `detail: "full"` unless necessary (wastes tokens)
- Forget nodeType prefix (`nodes-base.*`)
- Skip validation profiles
- Try to build workflows in one shot (iterate!)
- Ignore auto-sanitization behavior
- Use full prefix (`n8n-nodes-base.*`) with search/validate tools
- Forget to activate workflows after building

---

## Summary

**Most Important**:
1. Use **mcp_n8n-mcp_get_node** with `detail: "standard"` (default) - covers 95% of use cases
2. nodeType formats differ: `nodes-base.*` (search/validate) vs `n8n-nodes-base.*` (workflows)
3. Specify **validation profiles** (`runtime` recommended)
4. Use **smart parameters** (`branch="true"`, `case=0`)
5. Include **intent parameter** in workflow updates
6. **Auto-sanitization** runs on ALL nodes during updates
7. Workflows can be **activated via API** (`activateWorkflow` operation)
8. Workflows are built **iteratively** (56s avg between edits)

**Common Workflow**:
1. mcp_n8n-mcp_search_nodes → find node
2. mcp_n8n-mcp_get_node → understand config
3. mcp_n8n-mcp_validate_node → check config
4. mcp_n8n-mcp_n8n_create_workflow → build
5. mcp_n8n-mcp_n8n_validate_workflow → verify
6. mcp_n8n-mcp_n8n_update_partial_workflow → iterate
7. activateWorkflow → go live!

For details, see:
- [SEARCH_GUIDE.md](resources/SEARCH_GUIDE.md) - Node discovery
- [VALIDATION_GUIDE.md](resources/VALIDATION_GUIDE.md) - Configuration validation
- [WORKFLOW_GUIDE.md](resources/WORKFLOW_GUIDE.md) - Workflow management

---

**Related Skills**:
- n8n Expression Syntax - Write expressions in workflow fields
- n8n Workflow Patterns - Architectural patterns from templates
- n8n Validation Expert - Interpret validation errors
- n8n Node Configuration - Operation-specific requirements
- n8n Code JavaScript - Write JavaScript in Code nodes
- n8n SSDLC - Security protocol and MCP pipeline
