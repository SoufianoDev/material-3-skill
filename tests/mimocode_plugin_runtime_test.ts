import plugin from "../plugins/material-3-mimocode/index.ts"

const expectedSources = {
  overview: "SKILL.md",
  colors: "references/color-system.md",
  components: "references/component-catalog.md",
  layout: "references/layout-and-responsive.md",
  navigation: "references/navigation-patterns.md",
  theming: "references/theming-and-dynamic-color.md",
  typography: "references/typography-and-shape.md",
} as const

const hooks = await plugin.server({} as never)
const referenceTool = hooks.tool?.material_3_reference

if (!referenceTool) {
  throw new Error("MiMo Code plugin did not register material_3_reference")
}

for (const [topic, source] of Object.entries(expectedSources)) {
  const result = await referenceTool.execute({ topic } as never, {} as never)
  const expectedHeader = `Material Design 3 reference: ${topic}\nSource: ${source}\n\n`

  if (typeof result !== "string" || !result.startsWith(expectedHeader)) {
    throw new Error(`Unexpected result for topic "${topic}"`)
  }

  if (result.slice(expectedHeader.length).trim().length < 100) {
    throw new Error(`The "${topic}" reference content is missing or unexpectedly short`)
  }
}

console.log("MiMo Code plugin runtime smoke test passed for all 7 reference topics.")
