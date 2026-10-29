import { readFile } from "node:fs/promises"
import path from "node:path"
import { tool } from "@mimo-ai/plugin"
import type { PluginModule } from "@mimo-ai/plugin"

const REFERENCES = {
  overview: "SKILL.md",
  colors: "references/color-system.md",
  components: "references/component-catalog.md",
  layout: "references/layout-and-responsive.md",
  navigation: "references/navigation-patterns.md",
  theming: "references/theming-and-dynamic-color.md",
  typography: "references/typography-and-shape.md",
} as const

export type Material3ReferenceTopic = keyof typeof REFERENCES

const plugin: PluginModule = {
  id: "material-3-mimocode",
  async server() {
    return {
      tool: {
        material_3_reference: tool({
          description:
            "Read the Material Design 3 skill or a focused reference when implementing, reviewing, theming, or auditing an interface. Call this tool before making MD3-specific decisions; choose overview for the main skill, or a focused topic to reduce context size.",
          args: {
            topic: tool.schema
              .enum([
                "overview",
                "colors",
                "components",
                "layout",
                "navigation",
                "theming",
                "typography",
              ])
              .describe("Which Material Design 3 guidance to load"),
          },
          async execute({ topic }) {
            const relativePath = REFERENCES[topic as Material3ReferenceTopic]
            const file = path.join(import.meta.dirname, "skills", "material-3", relativePath)
            const content = await readFile(file, "utf8")
            return `Material Design 3 reference: ${topic}\nSource: ${relativePath}\n\n${content}`
          },
        }),
      },
    }
  },
}

export default plugin
