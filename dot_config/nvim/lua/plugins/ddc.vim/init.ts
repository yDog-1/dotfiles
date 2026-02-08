// deno-lint-ignore-file no-import-prefix
import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddc-vim@10.1.0/config";

const baseMatchers = ["matcher_prefix", "matcher_fuzzy"];
const baseSorters = ["sorter_fuzzy", "sorter_rank"];
const baseConverters = ["converter_fuzzy"];


export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments) {
    args.contextBuilder.setGlobal({
      ui: "pum",
      autoCompleteEvents: [
        "CmdLineEnter",
        "CmdlineChanged",
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "TextChangedT",
      ],
      sources: [
        "file",
        "denippet",
        "lsp",
        "skkeleton",
        "skkeleton_okuri",
        "buffer",
        "around",
      ],
      cmdlineSources: {
        ":": ["shell_native", "cmdline", "cmdline_history", "around"],
        "@": ["input", "cmdline_history", "file"],
        ">": ["input", "cmdline_history", "file", "around"],
        "/": ["around"],
        "?": ["around"],
        "-": ["around"],
        "=": ["input"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: baseMatchers,
          sorters: baseSorters,
          converters: baseConverters,
        },
        around: {
          matchers: [...baseMatchers, "matcher_length"],
        },
        buffer: {
          matchers: [...baseMatchers, "matcher_length"],
        },
        lsp: {
          mark: "LSP",
          forceCompletionPattern: String.raw`\.\w*|::\w*|->\w*`,
          isVolatile: true,
          sorters: [...baseSorters, "sorter_lsp_kind"],
          converters: [...baseConverters, "converter_kind_labels"],
          maxItems: 20,
        },
        denippet: {
          minKeywordLength: 1,
          minAutoCompleteLength: 1,
          maxItems: 4,
        },
        file: {
          isVolatile: true,
          minAutoCompleteLength: 1000,
          forceCompletionPattern: String.raw`\S/\S*`,
          maxItems: 8,
        },
        skkeleton: {
          mark: "SKK",
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
          minAutoCompleteLength: 1,
        },
        skkeleton_okuri: {
          mark: "SKK*",
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
        },
        cmdline: {
          mark: " ",
          isVolatile: true,
          sorters: [...baseSorters, "sorter_cmdline_history"],
          forceCompletionPattern: String.raw`\S/\S*|\.\w*`,
        },
        cmdline_history: {
          mark: " ",
        },
        shell_native: {
          mark: "ZSH",
          isVolatile: true,
          minAutoCompleteLength: 1,
          minKeywordLength: 0,
        },
      },
      sourceParams: {
        around: {
          maxSize: 30,
        },
        buffer: {
          requireSameFiletype: false,
        },
        lsp: {
          confirmBehavior: "replace",
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
          snippetEngine: "",
        },
        file: {
          displayFile: " ",
          displayDir: " ",
          displaySym: "sym",
          displaySymFile: "sym ",
          displaySymDir: "sym ",
        },
        shell_native: {
          shell: "zsh",
        },
      },
      filterParams: {
        matcher_prefix: {
          prefixLength: 3,
        },
        sorter_lsp_kind: {
          priority: [
            "Method",
            "Function",
            "Constructor",
            "Field",
            "Variable",
            "Class",
            "Interface",
            "Module",
            "Property",
            "Unit",
            "Value",
            "Enum",
            "Keyword",
            "Color",
            "File",
            "Reference",
            "Folder",
            "EnumMember",
            "Constant",
            "Struct",
            "Event",
            "Operator",
            "TypeParameter",
            "Text",
            "Snippet",
          ],
        },
        converter_kind_labels: {
          kindLabels: {
            Text: " ",
            Method: " ",
            Function: " ",
            Constructor: " ",
            Field: " ",
            Variable: " ",
            Class: " ",
            Interface: " ",
            Module: " ",
            Property: " ",
            Unit: " ",
            Value: " ",
            Enum: " ",
            Keyword: " ",
            Snippet: " ",
            Color: " ",
            File: " ",
            Reference: " ",
            Folder: " ",
            EnumMember: " ",
            Constant: " ",
            Struct: " ",
            Event: " ",
            Operator: " ",
            TypeParameter: " ",
          },
          kindHlGroups: {
            Method: "Function",
            Function: "Function",
            Constructor: "Function",
            Field: "Identifier",
            Variable: "Identifier",
            Class: "Structure",
            Interface: "Structure",
          },
        },
      },
    });
  }
}
