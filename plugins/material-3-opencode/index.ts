import { readFile } from "node:fs/promises"
import path from "node:path"
import { Plugin, Skill } from "@opencode/plugin"
import { parse } from "yaml"

type SkillFrontmatter = {
  name?: unknown
  description?: unknown
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value)
}

export default Plugin.define({
  id: "material-3",
  async setup(ctx) {
    const file = path.join(import.meta.dirname, "skills", "material-3", "SKILL.md")
    const raw = (await readFile(file, "utf8")).replace(/\r\n/g, "\n")
    const end = raw.startsWith("---\n") ? raw.indexOf("\n---\n", 4) : -1

    if (end < 0) {
      throw new Error("material-3: SKILL.md is missing a valid YAML frontmatter block")
    }

    const frontmatter = parse(raw.slice(4, end)) as unknown
    if (!isRecord(frontmatter)) {
      throw new Error("material-3: SKILL.md frontmatter must be a YAML mapping")
    }

    const metadata = frontmatter as SkillFrontmatter
    const name = typeof metadata.name === "string" && metadata.name.trim()
      ? metadata.name.trim()
      : "material-3"
    const description = typeof metadata.description === "string"
      ? metadata.description.trim()
      : ""

    if (!description) {
      throw new Error("material-3: SKILL.md frontmatter has no description; the skill would not be advertised")
    }

    const content = raw.slice(end + "\n---\n".length).replace(/^\n+/, "")

    await ctx.skill.transform((editor) => {
      editor.add({
        id: Skill.ID.make("material-3"),
        name: Skill.Name.make(name),
        description,
        path: Skill.Info.fields.path.make(file),
        content,
      })
    })
  },
})
